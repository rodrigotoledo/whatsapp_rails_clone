FactoryBot.define do
  factory :group do
    sequence(:name) {|n| "Group #{n}" }

    trait :with_users do
      after(:create) do |group|
        group.users << create_list(:user, 3)
      end
    end
  end
end
