# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :user do
    username
    secretary     { false }
    doctor        { false }
    admin         { false }
    cf
    label
    name          { 'Mario' }
    lastname      { 'Rossi' }
    city          { :other }
    factory :secretary do
      secretary   { true }
    end
    factory :doctor do
      doctor      { true }
    end
    factory :admin do
      admin       { true }
    end
    factory :all do
      secretary   { true }
      doctor      { true }
      admin       { true }
    end
  end
end
