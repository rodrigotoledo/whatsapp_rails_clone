require "rails_helper"

RSpec.describe Message, type: :model do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }
  let(:group) { create(:group) }

  context "validations" do
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:receiver_type) }

    it "validates receiver_type" do
      message = build(:message, sender: sender, content: "Hello", receiver_type: "Invalid")
      expect(message.valid?).to be_falsey
      expect(message.errors[:receiver_type]).to include("is invalid")
    end

    it "validates group_id when receiver_type is Group" do
      message = build(:message, sender: sender, content: "Hello", receiver_type: "Group")
      expect(message.valid?).to be_falsey
      expect(message.errors[:group_id]).to include("must be present when receiver is a Group")
    end

    it "validates receiver_id when receiver_type is User" do
      message = build(:message, sender: sender, content: "Hello", receiver_type: "User")
      expect(message.valid?).to be_falsey
      expect(message.errors[:receiver_id]).to include("must be present when receiver is a User")
    end
  end

  context "associations" do
    it { should belong_to(:sender).class_name("User") }
    it { should belong_to(:receiver).class_name("User").optional }
    it { should belong_to(:group).optional }
  end

  context "friendship creation" do
    it "adds sender and receiver as friends when not in a group" do
      create(:message, sender: sender, receiver: receiver, receiver_type: "User", content: "Hello")
      expect(sender.friends).to include(receiver)
      expect(receiver.friends).to include(sender)
    end

    it "does not add friendship when sender and receiver are the same" do
      create(:message, sender: sender, receiver: sender, receiver_type: "User", content: "Hello")
      expect(sender.friends).not_to include(sender)
    end
  end

  context 'when have scenarios over unread' do
    let!(:message) { create(:message, sender: sender, receiver_type: "User", receiver: receiver) }
    it { expect(message.unread?).to be_truthy }
    it "read message" do
      expect(message.read_message!).to be_truthy
      expect(message.unread?).to be_falsey
    end
  end
  
end
