FactoryBot.define do
  factory :message do
    association :sender, factory: :user
    association :receiver, factory: :user
    content { "This is a test message." }

    trait :group_message do
      group
      receiver { nil }
    end
  end
end
