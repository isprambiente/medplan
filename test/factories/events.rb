# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :event do
    ids { [] }
    start_at { Time.zone.now }
    date_on { Time.zone.now }
    gender { :visit }
    city { 'Rome' }
  end
end
