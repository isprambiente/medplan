# frozen_string_literal: true

# This model manage the events for analisys and visits
#
# === Relations
# * has many {Meeting}
# * has many {Audit} through {Meeting}
# * has many {User} through {Audit}
#
# === Validations
# * validate presence of {date_on}
# * validate uniqueness of {date_on} scope {city} and {gender}
# * validate presence of {start_at}
#
# === After Save
# * {add_meetings}
#
# === Default scope
# ordered by date_on asc
#
# @!attribute [rw] date_on
#   @return [Date] event's date
# @!attribute [rw] gender
#   is an enum with the possible type of event. Is mandatory.
#   @return [String] 'analisys' if value is 0
#   @return [String] 'visit' if value is 1
# @!attribute [rw] body
#   @return [String] optional description
# @!attribute [rw] city
#   @return [String] is the event's reference city
# @!attribute [rw] max_user
#   is mandatory, default is 10
#   @return [Integer] is the max number of {User} for the event
# @!attribute [rw] created_at
#   @return [Datetime] date when the record was created
# @!attribute [rw] updated_at
#   @return [Datetime] date when the record was updated
# @!attribute [rw] start_at
#   Is an attr_accessor, is required, is used for make related {Meeting}
#   @return [Datetime]
# @!attribute [rw] state
#   Is an attr_accessor, is the new state for related {Meeting}
#   @return [String]
# @!attribute [rw] ids
#   Is an attr_accessor, Is the list of related {User}, is required for create o update related meeting
#   @return [Array] list of {User}
# @!attribute [rw] user
#   Is an attr_accessor, Is a reference user
#   @return [Object] {User} instance
#
# @!method meetings()
#   @return [Array] of related {Meeting}
# @!method audits()
#   @return [Array] of related {Audit}
# @!method users()
#   @return [Array] of related {User}
# @!method self.between(start_on: Time.zone.today - 1.month, stop_on: Time.zone.today)
#   @return [Array] of {Event} with {date_on} from :start_on and :stop_on
# @!method future(start_on: Time.zone.today - 1.month, stop_on: Time.zone.today)
#   @return [Array] of {Event} with {date_on} greater than :date
class Event < ApplicationRecord
  has_many :meetings, dependent: :destroy
  has_many :audits, through: :meetings
  has_many :users, through: :audits
  has_many :user_meetings, ->(e) { where(audit_id: e.user.audit_ids) }, class_name: 'Meeting', inverse_of: :event
  attr_accessor :start_at, :state, :ids, :user

  validates :date_on, presence: true, uniqueness: { scope: %i[city gender] }
  validates :start_at, presence: true

  after_save :add_meetings

  enum :gender, { analisys: 0, visit: 1 }

  default_scope -> { order('date_on asc') }
  scope :between, ->(start_on: Time.zone.today - 1.month, stop_on: Time.zone.today) { where('date_on >= :start_on and date_on <= :stop_on', start_on: start_on, stop_on: stop_on) }
  scope :future, ->(date: Time.zone.today) { where('date_on >= ?', date) }
  scope :confirmed, -> { joins(:meetings).where(meetings: {status: :confirmed}) }

  # @return [String] {start_at} to string if present
  # @return [Null] if {start_at} is null
  def start_on
    start_at.to_datetime.strftime('%d/%m/%Y %H:%M:%S') if start_at.present?
  end

  # @return [Symbol] {audit.status} of first {Audit}
  # @return [Symbol] :not_assigned if no any {Audit} is present
  def status(user)
    meetings.find_by(audit_id: user.audit_ids).try(:status) || :not_assigned
  end

  # @return [String] strftime of {meeting.start_at} from first related {Meeting}
  def time(user)
    meeting = meetings.find_by(audit_id: user.audit_ids)
    meeting.start_at.strftime('%H:%M')
  end

  # @return [String] All {category.title} planed for this event for a {User}
  def categories(user)
    meetings.where(audit_id: user.audit_ids).map { |m| m.category.title }.join(', ')
  end

  # Update the status of the {Meeting} related to an User
  # @return [True] if all {Meeting} are updated
  # @return [False] if {Meeting} isn't updated
  def update_status!
    new_status = case status(user)
                 when 'proposed' then 2
                 when 'waiting' then 3
                 when 'confirmed' then 0
                 when 'blocked' then 1
                 end
    user_meetings.find_each { |m| m.update(status: new_status) }
  end

  private

  # Add or update all {Meeting} from {ids}
  def add_meetings
    audits = ids.compact
    audits.each { |audit| meetings.find_or_initialize_by(audit_id: audit).update(start_at: start_at, status: state) }
  end
end
