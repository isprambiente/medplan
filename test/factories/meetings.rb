# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :meeting do
    audit
    event
    user
    category
    start_at { Time.zone.now }
    body { 'MyText' }
  end
end
