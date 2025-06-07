# frozen_string_literal: true

unless Rails.env.production?
  PASSWORD_FOR_USER = "password123".freeze
end
