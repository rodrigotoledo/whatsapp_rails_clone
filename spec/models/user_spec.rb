require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:friendships) }
    it { should have_many(:friends).through(:friendships) }
    it { should have_and_belong_to_many(:groups) }
    it { should have_many(:sent_messages).class_name("Message").with_foreign_key("sender_id").dependent(:destroy) }
    it { should have_many(:received_messages).class_name("Message").with_foreign_key("receiver_id").dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:email_address) }
    it "validates uniqueness of email_address" do
      user = create(:user, email_address: "unique@example.com")
      duplicate_user = build(:user, email_address: user.email_address)
      expect(duplicate_user).not_to be_valid
    end
    it { should allow_value("user@example.com").for(:email_address) }
    it { should_not allow_value("invalid_email").for(:email_address) }
  end

  describe "normalization" do
    it "downcases and strips email_address" do
      user = create(:user, email_address: "  TEST@EXAMPLE.COM  ")
      expect(user.email_address).to eq("test@example.com")
    end
  end

  describe "#to_s" do
    it "returns the email address" do
      user = create(:user, email_address: "user@example.com")
      expect(user.to_s).to eq("user@example.com")
    end
  end

  describe "#chat_with" do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:group) { create(:group) }

    before do
      create(:message, sender: user, receiver: friend, receiver_type: "User", created_at: 1.day.ago)
      create(:message, sender: friend, receiver: user, receiver_type: "User", created_at: 2.days.ago)
      create(:message, sender: user, group: group, receiver_type: "Group", created_at: 3.days.ago)
    end

    it "returns messages between users ordered by creation date" do
      messages = user.chat_with(friend)
      expect(messages.count).to eq(2)
      expect(messages.first.created_at).to be < messages.last.created_at
    end

    it "returns messages from a group ordered by creation date" do
      messages = user.chat_with(group)
      expect(messages.count).to eq(1)
    end
  end
end
