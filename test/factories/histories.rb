# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :history do
    audit
    author { 'MyString' }
    doctor { 'MyString' }
    status { 'created' }
    body { 'MyString' }
    lab  { 'Lab' }
    revision_date { Time.zone.now }
    log { true }
    city { 1 }
  end
end
