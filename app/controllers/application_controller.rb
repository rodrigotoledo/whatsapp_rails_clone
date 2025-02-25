class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # before_action :set_groups, if: :authenticated?

  # private
  # def set_groups
  #   @groups =
  # end
end
