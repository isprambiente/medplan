# frozen_string_literal: true

# This model save the clinical history of the users
#
# === Relation
# belongs to {Audit}
# belongs to {User} as {doctor}
# belongs to {User} as {author}
# has one {User} through {Audit}
# has one {Category} through {Audit}
# has one {Risk} through {Audit}
# has one {CategoryRisk} through {Category}
#
# === Validations
# validate presence of {revision_date}
# validate presence of {doctor_id} if {require_doctor?}
# validate presence of {author_id}
# validate presence of {status}
# validate inclusion of {status} in statuses listed in config/settings.yml
#
# ### Before validation
# {prerequisite}
#
# @!attribute [rw] id
#   @return [Integer] the unique identifier for {History}
# @!attribute [rw] audit_id
#   @return [Integer] reference id for {Audit}
# @!attribute [rw] doctor_id
#   @return [Integer] reference id for {User} as {doctor}
# @!attribute [rw] author_id
#   @return [Integer] reference id for {User} as {author}
# @!attribute [rw]  status
#   @return [String]
# @!attribute [rw] revision_date
#   @return [Datetime] Date of the related event
# @!attribute [rw] body
#   @return [String] hystory note
# @!attribute [rw] lab
#   @return [String] name of related lab
# @!attribute [rw] city
#   @return [String] name of related city
# @!attribute [rw] created_at
#   @return [Datetime] date when the record was created
# @!attribute [rw] updated_at
#   @return [Datetime] date when the record was updated
#
# @!method audit()
#   @return [Object] related {Audit}
# @!method doctor()
#   @return [Object] related {User) as doctor
# @!method author()
#   @return [Object] related {User} as author
# @!method user()
#   @return [Object] related {User} through {Audit}
# @!method category()
#   @return [Object] related {Category} through {Audit}
# @!method category_risks()
#   @return [Object] related {CategoryRisk} through {Category}
# @!method risk()
#   @return [Object] related {Risk} through {CategoryRisk}
class History < ApplicationRecord
  belongs_to :audit
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id', optional: :require_doctor?, inverse_of: :audits
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', optional: false, inverse_of: :audits
  has_one :user, through: :audit
  has_one :category, through: :audit
  has_one :category_risks, through: :category
  has_one :risk, through: :category_risks
  validates :revision_date, presence: true
  validates :doctor_id, presence: true, if: :require_doctor?
  validates :author_id, presence: true
  validates :status, presence: true, inclusion: Settings.history.status
  before_validation :prerequisite

  scope :active, -> { where.not(status: 'change_date_next_visit') }
  scope :between, ->(start_on: Time.zone.now.beginning_of_year, stop_on: Time.zone.now.end_of_year) { where(revision_date: start_on..stop_on) }
  scope :availables, -> { where.not(status: %w[created deleted change_date_next_visit]) }

  # override update. {History} can't be updated
  # @return [False]
  def update
    false
  end

  # override delete. {History} can't be destroyed
  # @return [False]
  def delete
    false
  end

  # override destroy. {History} can't be destroyed
  # @return [False]
  def destroy
    false
  end

  private

  # preset some attributes before validation
  def prerequisite
    self.revision_date = Time.zone.now if revision_date.blank?
    audit.expire = revision_date.to_date
    audit.status = status
  end

  # @return [True] if status isn't created or deleted
  def require_doctor?
    %w[created deleted].exclude?(status)
  end
end
