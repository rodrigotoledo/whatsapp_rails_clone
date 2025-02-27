require "rails_helper"

RSpec.describe Friendship, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:friendship) { build(:friendship, user: user1, friend: user2) }

  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:friend).class_name("User") }
  end

  context "validations" do
    it "is valid with both user and friend" do
      expect(friendship).to be_valid
    end

    it "is invalid without a user" do
      friendship.user = nil
      expect(friendship).not_to be_valid
      expect(friendship.errors[:user]).to include("can't be blank")
    end

    it "is invalid without a friend" do
      friendship.friend = nil
      expect(friendship).not_to be_valid
      expect(friendship.errors[:friend]).to include("can't be blank")
    end
  end

  context "unique friendship" do
    it "does not allow duplicate friendships" do
      duplicate_friendship = build(:friendship, user: user1, friend: user1)
      expect(duplicate_friendship).not_to be_valid
    end
  end
end
