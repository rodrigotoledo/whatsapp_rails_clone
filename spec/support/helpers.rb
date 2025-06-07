# frozen_string_literal: true

require "factory_bot_rails"
require "shoulda/matchers"
require "rspec/json_expectations"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
