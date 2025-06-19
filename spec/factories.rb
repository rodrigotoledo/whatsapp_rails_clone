FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
  end

  factory :conversation do
    conversation_type { 'direct' }
  end

  factory :conversation_participant do
    conversation
    user
    last_read_at { Faker::Time.backward(days: 7) }
  end

  factory :friendship do
    user
    friend { create(:user) }
    status { 'pending' }
  end

  factory :group do
    name { Faker::Lorem.word.capitalize }
    conversation
  end

  factory :message do
    conversation
    sender { create(:user) }
    content { Faker::Lorem.sentence }
  end

  factory :message_read_status do
    message
    user
    read_at { Faker::Time.backward(days: 7) }
  end

  factory :session do
    user
    ip_address { Faker::Internet.ip_v4_address }
    user_agent { Faker::Internet.user_agent }
  end
end
