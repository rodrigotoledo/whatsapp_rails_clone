FactoryBot.define do
  factory :user do
    sequence(:email_address) {|n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :with_sessions do
      after(:create) do |user|
        create_list(:session, 2, user: user)
      end
    end
  end
end
