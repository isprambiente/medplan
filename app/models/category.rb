# frozen_string_literal: true

# This model manage the categories of work's risks
#
# @!attribute [rw] id
#   @return [Integer] is the unique identifier for {Category}
# @!attribute [rw] code
#   @return [String] Category code
# @!attribute [rw] title
#   @return [String] Category Title, can't be Null, default is an empty string
# @!attribute [rw] months
#   @return [Integer] periodicity of checks expressed in months, can't be Null, default 0
# @!attribute [rw] protocol
#   @return [String] description of check required
# @!attribute [rw] active
#   @return [Boolean] if category is active or not, can't be Null, default True
# @!attribute [rw] created_at
#   @return [Datetime] date when the record was created
# @!attribute [rw] updated_at
#   @return [Datetime] date when the record was updated
#
# === Relations
# has many {Audit}
# has many {CategoryRisk}
# has many {Risk} through {CategoryRisk}
# has many {User} through {Audit}
#
# === Validations
# * validate presence of {title}
# * validate uniqueness of {title}
# * validate presence of {months}
# * validate if {months} is a Integer
#
# === Default scope
# where active is true ordered by title
#
# @!method disabled()
#   @return [Array] of disablec {Category}
# @!method audit()
#   @return [Array] of {Audit} referenced from {Audit.category_id}
# @!method category_risks()
#   @return [Array] of {CategoryRisk} referenced from {CategoryRisk.category_id}
class Category < ApplicationRecord
  has_many :audits, dependent: :restrict_with_exception
  has_many :category_risks, dependent: :restrict_with_exception
  has_many :risks, through: :category_risks
  has_many :users, through: :audits

  validates :title, presence: true
  validates_uniqueness_of :title, conditions: -> { where(active: true) }
  validates :months, presence: true, numericality: { only_integer: true }

  default_scope { order('title asc').where(active: true) }
  scope :disabled, -> { unscoped.where(active: false).order('title asc') }

  # for security reason is an alias of {destroy}
  def delete
    destroy
  end

  # @return [Boolean] if category is unused and can be destroyed run Super, otherwise update for set active as false.
  def destroy
    if users.present? || risks.present?
      update(active: false)
    else
      super
    end
  end
end
