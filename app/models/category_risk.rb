# frozen_string_literal: true

# This model manage the links from {Category} and {Risk}
#
# === Relation
# * belongs to {Category}
# * belongs to {Risk}
#
# === Validations
# * Validate uniqueness of {category_id} scope {risk_id}
#
# @!attribute [rw] id
#   @return [Integer] is the unique identifier for {CategoryRisk}
# @!attribute [rw] category_id
#   @return [Integer] reference id to {Category}
# @!attribute [rw] risk_id
#   @return [Integer] reference id to {Risk}
#
# @!method category()
#   @return [Object] instance of referenced {Category}
# @!method risk()
#   @return [Object] instance of referenced {Risk}
# @!attribute [rw] created_at
#   @return [Datetime] date when the record was created
# @!attribute [rw] updated_at
#   @return [Datetime] date when the record was updated
class CategoryRisk < ApplicationRecord
  belongs_to :category
  belongs_to :risk

  validates :category, uniqueness: { scope: :risk }
end
