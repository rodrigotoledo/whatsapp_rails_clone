# spec/models/conversation_spec.rb
require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:group) { create(:group) }

  describe 'associations' do
    it { should have_many(:conversation_participants) }
    it { should have_many(:participants).through(:conversation_participants) }
    it { should have_many(:messages) }
    it { should have_one(:group) }
  end

  describe 'scopes' do
    let!(:direct_conversation) { create(:conversation, conversation_type: 'direct') }
    let!(:group_conversation) { create(:conversation, conversation_type: 'group', group: group) }

    it 'returns only group conversations' do
      expect(Conversation.only_groups).to contain_exactly(group_conversation)
    end
  end

  describe 'validations' do
    context 'when group conversation' do
      subject { build(:conversation, conversation_type: 'group', group: group) }
      it { should validate_presence_of(:group) }
    end

    context 'when direct conversation' do
      subject { build(:conversation, conversation_type: 'direct') }
      it { should_not validate_presence_of(:group) }
    end
  end

  describe '#mark_as_read_for' do
    let(:conversation) { create(:conversation, conversation_type: 'direct') }
    let!(:participant) { create(:conversation_participant, conversation: conversation, user: user1) }

    it 'updates last_read_at' do
      expect {
        conversation.mark_as_read_for(user1)
      }.to change { participant.reload.last_read_at }
    end
  end

  describe '#display_name' do
    context 'for group conversation' do
      let(:conversation) { create(:conversation, conversation_type: 'group', group: group) }

      it 'returns group name' do
        expect(conversation.display_name(user1)).to eq(group.name)
      end
    end

    context 'for direct conversation' do
      let(:conversation) { create(:conversation, conversation_type: 'direct') }
      before { conversation.participants << [user1, user2] }

      it 'returns other participant email' do
        expect(conversation.display_name(user1)).to eq(user2.email_address)
      end
    end
  end

  describe '#group?' do
    it 'returns true for group conversation' do
      conversation = build(:conversation, conversation_type: 'group')
      expect(conversation.group?).to be true
    end

    it 'returns false for direct conversation' do
      conversation = build(:conversation, conversation_type: 'direct')
      expect(conversation.group?).to be false
    end
  end

  describe '#unread_count_for' do
    let(:conversation) { create(:conversation, conversation_type: 'direct') }
    let!(:participant) { create(:conversation_participant, conversation: conversation, user: user1) }
    let!(:read_message) do
      create(:message, conversation: conversation, sender: user2, created_at: 1.day.ago).tap do |m|
        participant.update(last_read_at: 1.hour.ago)
      end
    end
    let!(:unread_messages) { create_list(:message, 2, conversation: conversation, sender: user2) }

    it 'returns count of unread messages' do
      expect(conversation.unread_count_for(user1)).to eq(2)
    end
  end
end
