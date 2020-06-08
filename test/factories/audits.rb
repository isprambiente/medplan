# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :audit do
    association :user
    association :category
    revision_date { Time.zone.now }
    status { 'created' }
    author { 'Andrea' }
    doctor { 'andrea' }
    lab { 'Fortezza delle scienze' }

    # after(:create) { |audit| FactoryBot.create(:event, audits: [audit]) }
  end
end
