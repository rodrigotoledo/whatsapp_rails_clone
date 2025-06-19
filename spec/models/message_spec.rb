# frozen_string_literal: true

require "rails_helper"

RSpec.describe Message, type: :model do
  let(:sender) { create(:user) }
  let(:receiver) { create(:user) }
  let(:group) { create(:group) }

  context "validations" do
    it { should validate_presence_of(:sender) }
    it { should validate_presence_of(:content) }
  end

  context "associations" do
    it { should belong_to(:sender).class_name("User") }
    it { should belong_to(:conversation) }
    it { should have_many(:message_read_statuses) }
  end
end
