require "factory_bot_rails"
require "shoulda/matchers"
require "rspec/json_expectations"
require "pry"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    PASSWORD_FOR_USER = "password123"
  end
end
