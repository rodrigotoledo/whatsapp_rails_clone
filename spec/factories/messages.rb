FactoryBot.define do
  factory :message do
    association :sender, factory: :user
    association :receiver, factory: :user
    content { "This is a test message." }
    receiver_type { "User" }

    trait :group_message do
      receiver_type { "Group" }
      group
      receiver { nil }
    end

    trait :unread_message do
      unread { true }
    end
  end
end
