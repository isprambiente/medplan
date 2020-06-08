# frozen_string_literal: true

# This model save the clinical meetings of the users
#
# === Relations
# * belongs to {Audit}
# * belongs to {Event}
# * has one {User} through {Audit}
# * has one {Category} through {Audit}
#
# === Validations
# * validate presence of {event}
# * validate uniqueness of {event}
# * validate presence of {audit}
# * validate presence of {start_at}
#
# === before_validation
# {check_stop_at}
#
# === after_destroy
# {check_event}
#
# @!attribute [rw] id
#   @return [Integer] the unique identifier for {Meeting}
# @!attribute [rw] audit_id
#   @return [Integer] reference id for {Audit}
# @!attribute [rw] event_id
#   @return [Integer] reference id for {Event}
# @!attribute [rw] status
#   Is an enum, can't be null, default is 1
#   @return [Symbol] :blocked when 0
#   @return [Symbol] :proposed when 1
#   @return [Symbol] :waiting when 2
#   @return [Symbol] :confirmed when 3
# @!attribute [rw] start_at
#   @return [Time] Start time for {Meeting}, can't be null
# @!attribute [rw] stop_at
#   @return [Time] Stop time for {Meeting}, can't be null
# @!attribute [rw] body
#   @return [String] Description
# @!attribute [rw] active
#   Da definire
# @!attribute [rw] sended_at
#   @return [DateTime] the date when the {Meeting} is sended to the {user}
# @!attribute [rw] created_at
#   @return [DateTime] the date when the record was created
# @!attribute [rw] updated_at
#   @return [DateTime] the date when the record was updated
#
# @!method audit()
#   @return [Object] related {Audit}
# @!method event()
#   @return [Object] related {Event}
# @!method user()
#   @return [Object] related {User} through {Audit}
# @!method category()
#   @return [Object] related {Category} through {Audit}
class Meeting < ApplicationRecord
  belongs_to :audit
  belongs_to :event
  has_one :user, through: :audit
  has_one :category, through: :audit

  attr_accessor :active

  enum status: { blocked: 0, proposed: 1, waiting: 2, confirmed: 3 }

  validates :event, presence: true, uniqueness: { scope: :audit }
  validates :audit, presence: true
  validates :start_at, presence: true

  before_validation :check_stop_at
  after_destroy :check_event

  # @return [Object] return an ICAL object with meeting data
  def ical
    require 'icalendar'
    require 'icalendar/tzinfo'
    cal = Icalendar::Calendar.new
    event_start = DateTime.parse(I18n.l(event.date_on, format: :date).to_s + "T#{I18n.l(start_at, format: :time)}")

    tzid = 'Europe/Rome'
    tz = TZInfo::Timezone.get tzid
    timezone = tz.ical_timezone Time.zone.now
    cal.add_timezone timezone

    cal.event do |e|
      e.dtstart = Icalendar::Values::DateTime.new event_start, 'tzid' => tzid
      e.dtend   = Icalendar::Values::DateTime.new event_start, 'tzid' => tzid
      e.summary = "Prenotazione #{I18n.t(event.gender, scope: 'event.gender').downcase} del #{I18n.l(event.date_on)} alle ore #{I18n.l(start_at, format: :time)}"
      e.organizer = "mailto:#{Settings.email}"
      e.organizer = Icalendar::Values::CalAddress.new("mailto:#{Settings.email}", cn: user.label)
      e.description = Settings.events[event.gender]['description']
      e.location = Settings.events[event.gender]['location']
    end
  end

  private

  # @return [Time] start_at + 20 minutes if stop_at is empty and start_at is present
  # @return [Null] if stop_at if is present
  def check_stop_at
    self.stop_at = start_at.in_time_zone + 20.minutes if stop_at.blank? && start_at.present?
  end

  # @return [True] if {Event.meetings} is empty and the event is destroyed
  # @return [False] if {Event.meetings} is empty and the event isn't destroyed
  # @return [Null] if {Event.meetings} isn't empty
  def check_event
    event.destroy if event.reload.meetings.blank?
  end
end
