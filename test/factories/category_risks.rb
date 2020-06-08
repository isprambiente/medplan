# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryBot.define do
  factory :category_risk do
    category
    risk
  end
end
