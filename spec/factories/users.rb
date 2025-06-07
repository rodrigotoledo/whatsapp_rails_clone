# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { PASSWORD_FOR_USER }
    password_confirmation { PASSWORD_FOR_USER }

    trait :with_sessions do
      after(:create) do |user|
        create_list(:session, 2, user: user)
      end
    end
  end
end
