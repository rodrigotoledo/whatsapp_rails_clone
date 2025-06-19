# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }
  let(:group) { create(:group) }
  let(:conversation) { create(:conversation) }

  describe 'validations' do
    it { should validate_presence_of(:email_address) }
    it 'validates uniqueness of email_address (case insensitive)' do
      create(:user, email_address: 'test@example.com')
      new_user = build(:user, email_address: 'TEST@example.com')
      expect(new_user).not_to be_valid
      expect(new_user.errors[:email_address]).to include('has already been taken')
    end
    it { should allow_value('valid@example.com').for(:email_address) }
    it { should_not allow_value('invalid').for(:email_address) }
  end

  describe 'associations' do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_many(:group_memberships) }
    it { should have_many(:groups).through(:group_memberships) }
    it { should have_many(:friendships) }
    it { should have_many(:friends).through(:friendships) }
    it { should have_many(:conversation_participants) }
    it { should have_many(:conversations).through(:conversation_participants) }
    it { should have_many(:messages).with_foreign_key('sender_id').dependent(:destroy) }
  end

  describe 'normalizations' do
    it 'normalizes email_address to lowercase' do
      user = create(:user, email_address: 'TEST@EXAMPLE.COM')
      expect(user.email_address).to eq('test@example.com')
    end

    it 'strips whitespace from email_address' do
      user = create(:user, email_address: ' test@example.com ')
      expect(user.email_address).to eq('test@example.com')
    end
  end

  describe '#to_s' do
    it 'returns email_address' do
      expect(user.to_s).to eq(user.email_address)
    end
  end

  describe '#unread_messages' do
    let!(:participant) { create(:conversation_participant, user: user, conversation: conversation) }
    let!(:read_message) do
      create(:message, conversation: conversation, sender: friend, created_at: 1.day.ago).tap do |m|
        participant.update(last_read_at: 1.hour.ago)
      end
    end
    let!(:unread_message) { create(:message, conversation: conversation, sender: friend) }

    it 'returns only unread messages' do
      expect(user.unread_messages).to include(unread_message)
      expect(user.unread_messages).not_to include(read_message)
    end
  end

  describe '#unread_messages_count' do
    let!(:participant) { create(:conversation_participant, user: user, conversation: conversation) }
    let!(:read_message) do
      create(:message, conversation: conversation, sender: friend, created_at: 1.day.ago).tap do |m|
        participant.update(last_read_at: 1.hour.ago)
      end
    end
    let!(:unread_messages) { create_list(:message, 3, conversation: conversation, sender: friend) }

    it 'returns count of unread messages' do
      expect(user.unread_messages_count).to eq(3)
    end
  end

  describe '#friends' do
    before do
      create(:friendship, user: user, friend: friend, status: 'accepted')
      create(:friendship, user: user, friend: create(:user), status: 'pending')
    end

    it 'returns only accepted friends' do
      expect(user.friends).to contain_exactly(friend)
    end
  end
end
