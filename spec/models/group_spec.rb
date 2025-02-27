require "rails_helper"

RSpec.describe Group, type: :model do
  let(:group) { build(:group, name: "My Group") }

  context "validations" do
    it "is valid with a name" do
      expect(group).to be_valid
    end

    it "is invalid without a name" do
      group.name = nil
      expect(group).not_to be_valid
      expect(group.errors[:name]).to include("can't be blank")
    end
  end

  context "associations" do
    it { should have_many(:messages).dependent(:destroy) }
  end

  context "instance methods" do
    it "returns the name as a string" do
      expect(group.to_s).to eq("My Group")
    end
  end
end
