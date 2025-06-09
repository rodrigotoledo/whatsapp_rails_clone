# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::Messages", type: :request do
  let!(:user) { create(:user) }
  let!(:group) { create(:group) }
  let!(:friend) { create(:user) }

  describe "GET /messages" do
    it "get messages with another user" do
      user.friends << friend
      user.sent_messages.create!(receiver_id: friend.id, receiver_type: 'User', content: 'message okay')
      user.sent_messages.create!(receiver_id: friend.id, receiver_type: 'User', content: 'message okay')
      get api_messages_path(friend_id: friend.id), headers: generate_jwt_token(user)
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key("messages")
      expect(json_response["messages"].size).to eql(2)
    end

    it "get messages inside a group" do
      user.groups << group
      user.save!
      user.sent_messages.create!(group_id: group.id, receiver_type: 'Group', content: 'message for group')
      user.sent_messages.create!(group_id: group.id, receiver_type: 'Group', content: 'message for group')
      user.sent_messages.create!(group_id: group.id, receiver_type: 'Group', content: 'message for group')
      get api_messages_path(group_id: group.id), headers: generate_jwt_token(user)
      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response).to have_key("messages")
      expect(json_response["messages"].size).to eql(3)
    end
  end
end
