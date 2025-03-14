# frozen_string_literal: true

# This model manage the user's medical check for a risk
#
# @!attribute [rw] user_id
#   @return [Integer] reference id of {User}, can't be Null
# @!attribute [rw] category_id
#   @return [Integer] reference id of {Category}, can't be null
# @!attribute [rw] status
#   Possible statuses:
#   * deleted: 0,
#   * created: 1,
#   * suitable: 2,
#   * suitable_prescription_temporary: 3,
#   * suitable_prescription_permanent: 4,
#   * unsuitable_temporary: 5,
#   * unsuitable_permanent: 6
#   @return [String] Is the audit status, is an enum, can't be null, default status is :created.
# @!attribute [rw] expire
#   @return [Date] expire date for the {Audit}
# @!attribute [rw] created_at
#   @return [Datetime] date when the record was created
# @!attribute [rw] updated_at
#   @return [Datetime] date when the record was updated
#
# === Relation
# * belongs to {User}
# * belongs to {Category}
# * has one {History} (is the last history entry)
# * has many {History}
# * has many {Meeting}
# * has many {Event} through {Meeting}
# === Validations
# * Validate presence of {User} relation
# * Validate presence of {Category} relation
# * Validate presence of :status
# * Validate presence of :expire
# === Default scope
# where.not(status: 0)
# @!method self.expire_beetween(start_at = Time.zone.now.to_date, stop_at = Time.zone.now.to_date)
#   select all {Audit} inside a period
#   @param start_at [Datetime] start date for the query
#   @param stop_at [Date] end date for the query
#   @return [Array] of {Audit} from :start to :stop_at
# @!method self.expired(date: Date.today.end_of_month)
#   Select all {Audit} expired in a date
#   @param date {Date} start date for query
#   @return [Array] of {Audit} expired before :date
# @!method self.get_calendar(start_at = Time.zone.now.to_date, stop_at = Time.zone.now.to_date)
#   specific query for make a calendar
#   @param start_at [Datetime] start date for the query
#   @param stop_at [Date] end date for the query
#   @return [Array] of {Audit} from :start to :stop_at with expire and count, group and order by expire
class Audit < ApplicationRecord
  belongs_to  :user
  belongs_to  :category
  has_many    :histories, dependent: :destroy
  has_one     :history, -> { order created_at: :desc }, class_name: 'History', foreign_key: :audit_id, inverse_of: :audit
  has_many    :meetings, dependent: :destroy
  has_many    :events, through: :meetings, dependent: :destroy

  store_accessor :metadata, :author, :revision_date

  validates :user_id, presence: true
  validates :category_id, presence: true, uniqueness: { scope: %i[user_id status] }
  validates :status, presence: true
  validates :expire, presence: true

  enum :status, {
    deleted: 0,
    created: 1,
    suitable: 2,
    suitable_prescription_temporary: 3,
    suitable_prescription_permanent: 4,
    unsuitable_temporary: 5,
    unsuitable_permanent: 6
  }

  default_scope { where.not(status: 0) }
  scope :ordered_by_category_title, -> { joins(:category).order('categories.title') }
  scope :expire_beetween, ->(start_at = Time.zone.now.to_date, stop_at = Time.zone.now.to_date) { where(expire: start_at..stop_at) }
  scope :expired, ->(date: Time.zone.today.end_of_month) { where('expire <= ?', date) }
  scope :get_calendar, ->(start_at = Time.zone.now.to_date, stop_at = Time.zone.now.to_date) { expire_beetween(start_at, stop_at).select('expire as expire', 'Count(Distinct audits.user_id) as count').group('expire').order('expire') }

  accepts_nested_attributes_for :histories, allow_destroy: false, limit: 1

  # is an alias of history relation
  # @return [Object] return last {Audit}'s {History}
  def state
    history
  end

  # For security reason is an alias of {destroy}
  def delete
    destroy
  end

  # Override default destroy end return everytime false. {Audit} record cannot be destroyed
  # @return [False]
  def destroy
    false
  end

  # @return [String] based on {expired?} response 'expired' o 'active'
  def status_class
    expired? ? 'expired' : 'active'
  end

  # @return [Boolean] true if {Audit} is expired
  def expired?
    expire <= Time.zone.now
  end
end
