require "rails_helper"

RSpec.describe HomeHelper, type: :helper do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    @receiver = user2

    allow(Current).to receive(:user).and_return(user1)
    allow(user1).to receive(:chat_with).with(@receiver).and_return(@receiver)
  end

  describe "#chat_with" do
    it "returns the correct chat partner" do
      expect(helper.chat_with).to eq(@receiver)
    end

    it "memoizes the result" do
      helper.chat_with
      expect(user1).to have_received(:chat_with).once.with(@receiver)
    end
  end
end
