# frozen_string_literal: true

FactoryBot.define do
  sequence(:title)     { |n| "title_#{n}" }
  sequence(:code)      { |n| "code_#{n}" }
  sequence(:username)  { |n| "user_#{n}" }
  sequence(:email)     { |n| "user_#{n}@example.com" }
  sequence(:cf)        { |n| "123456789_#{n}" }
  sequence(:label)     { |n| "label_#{n}" }
end
