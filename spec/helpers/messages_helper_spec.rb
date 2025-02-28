require "rails_helper"

RSpec.describe MessagesHelper, type: :helper do
  let(:user) { create(:user) }
  let(:receiver) { create(:user) }
  let!(:messages) { create_list(:message, 4, sender: user, receiver: receiver) }

  it "returns the unread message for the current user" do
    expect(helper.unread_messages_for_user(receiver)).to be(4)
  end

  it "returns the unread message for the user" do
    expect(helper.unread_messages_for_user(user)).to be(0)
  end
end
