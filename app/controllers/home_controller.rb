class HomeController < ApplicationController
  before_action :set_receiver, only: :index

  def index; end

  private

  def set_receiver
    return if params[:group_id].blank? && params[:friend_id].blank?

    @receiver = if params[:group_id].present?
                  Current.user.groups.find_by(id: params[:group_id])
                elsif params[:friend_id].present?
                  Current.user.friends.find_by(id: params[:friend_id])
                end
  end
end
