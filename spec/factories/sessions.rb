FactoryBot.define do
  factory :session do
    user
    ip_address { "192.168.0.1" }
    user_agent { "RSpec Test Agent" }
  end
end
