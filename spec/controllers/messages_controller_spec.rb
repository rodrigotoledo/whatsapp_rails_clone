require "rails_helper"
RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:receiver) { create(:user) }
  let(:valid_attributes) { {content: "Test message", receiver_id: receiver.id, receiver_type: "User"} }
  let(:invalid_attributes) { {content: "", receiver_id: nil, receiver_type: "User"} }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new message" do
        expect {
          post :create, params: {message: valid_attributes}
        }.to change(Message, :count).by(1)
      end

      it "redirects to the root path with a notice" do
        post :create, params: {message: valid_attributes}
        expect(response).to redirect_to(root_path(group_id: assigns(:message).group_id, friend_id: assigns(:message).receiver_id))
        expect(flash[:notice]).to eq("Message sent successfully!")
      end
    end

    context "with invalid attributes" do
      it "does not create a new message" do
        expect {
          post :create, params: {message: invalid_attributes}
        }.not_to change(Message, :count)
      end

      it "redirects to the root path with an alert" do
        post :create, params: {message: invalid_attributes}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Content can't be blank and Receiver must be present when receiver is a User")
      end
    end
  end

  describe "PUT /messages/mark_as_read" do
    it "marks all unread messages as read" do
      put :mark_as_read

      expect(response).to have_http_status(:success)
      expect(user.unread_messages.count).to eq(0)
    end
  end
end
