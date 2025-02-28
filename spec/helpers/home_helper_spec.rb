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

  describe "#receiver_message_box" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    before do
      allow(Current).to receive(:user).and_return(user)
    end

    context "quando @receiver é um grupo" do
      it "retorna o próprio grupo" do
        assign(:receiver, group)
        expect(helper.receiver_message_box).to eq(group)
      end
    end

    context "quando @receiver NÃO é um grupo" do
      it "retorna Current.user" do
        assign(:receiver, user) # ou nil
        expect(helper.receiver_message_box).to eq(user)
      end
    end
  end
end
