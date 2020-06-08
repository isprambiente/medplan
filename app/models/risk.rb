# frozen_string_literal: true

# This model manage the risks of work
# === Relations
# has many {CategoryRisk}
# has many {Category}, through {CategoryRisk}
# === Validates
# * presence of {title}
# * uniqueness of {title}
# === Default scope
# * order by title asc
#
# @!attribute [rw] id
#   @return [Integer] unique identifier for {Risk}
# @!attribute [rw] code
#   @return [String] Short code of {Risk}
# @!attribute [rw] title
#   @return [String] full title of {Risk}, can't be null, default is empty string
# @!attribute [rw] printed
#   @return [Boolean] if {Risk} enter in the reports, can't be null, default is true
# @!attribute [rw] created_at
#   @return [DateTime] when the record was created
# @!attribute [rw] updated_at
#   @return [DateTime] when the record was updated
#
# @!method self.printed()
#   @return [Array] all {Risk} with {printed} true, order by code
class Risk < ApplicationRecord
  has_many :category_risks, dependent: :restrict_with_exception
  has_many :categories, through: :category_risks

  validates :title, presence: true, uniqueness: true

  default_scope { order('title asc') }

  scope :printed, -> { unscoped.where(printed: true).order(:code) }
end
