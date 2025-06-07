# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include Api::Authentication
  end
end
