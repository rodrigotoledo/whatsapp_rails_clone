# spec/models/group_spec.rb
require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:conversation) }
    it { should have_many(:group_memberships) }
    it { should have_many(:users).through(:group_memberships) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'callbacks' do
    context 'when creating new group' do
      it 'automatically creates conversation' do
        group = Group.new(name: 'Test Group')
        expect { group.save }.to change(Conversation, :count).by(1)
      end

      it 'sets conversation_type to group' do
        group = create(:group, conversation: nil)
        expect(group.conversation.conversation_type).to eq('group')
      end
    end
  end

  describe '#to_s' do
    it 'returns group name' do
      group = build(:group, name: 'Test Group')
      expect(group.to_s).to eq('Test Group')
    end
  end

  describe '#add_member' do
    let(:group) { create(:group) }

    it 'adds user to conversation participants' do
      expect {
        group.add_member(user)
      }.to change { group.conversation.participants.count }.by(1)
    end

    it 'does not duplicate existing members' do
      group.add_member(user)
      expect {
        group.add_member(user)
      }.not_to change { group.conversation.participants.count }
    end
  end
end
