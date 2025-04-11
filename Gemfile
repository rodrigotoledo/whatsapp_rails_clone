source "https://rubygems.org"

# Core Rails
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.2"
gem "sqlite3"

# Frontend
gem "importmap-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 4.1"
gem "turbo-rails"

# Authentication
gem "bcrypt", "~> 3.1.7"

# Background processing and caching
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Performance
gem "bootsnap", require: false
gem "kamal", require: false

# Windows compatibility
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  # Environment
  gem "dotenv-rails"

  # Testing
  gem "factory_bot_rails"
  gem "faker"
  gem "guard-rspec", require: false
  gem "rails-controller-testing"
  gem "rspec-json_expectations"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov", require: false

  # Debugging
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Security
  gem "brakeman", require: false

  # Code quality
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Email preview
  gem "letter_opener"
  gem "letter_opener_web"

  # Console
  gem "web-console"
end
