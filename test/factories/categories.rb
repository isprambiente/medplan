# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryBot.define do
  factory :category do
    sequence(:code) { |n| "code_#{n}" }
    sequence(:title) { |n| "title_#{n}" }
    months { 1 }
    protocol { 'MyText' }
  end
end
