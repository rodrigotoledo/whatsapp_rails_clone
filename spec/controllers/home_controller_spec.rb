require "rails_helper"
RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:friend) { create(:user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    context "when group_id is provided" do
      it "sets the @receiver to the correct group" do
        user.groups << group
        get :index, params: {group_id: group.id}
        expect(assigns(:receiver)).to eq(group)
      end
    end

    context "when friend_id is provided" do
      it "sets the @receiver to the correct friend" do
        user.friends << friend
        get :index, params: {friend_id: friend.id}
        expect(assigns(:receiver)).to eq(friend)
      end
    end

    context "when neither group_id nor friend_id is provided" do
      it "does not set @receiver" do
        get :index
        expect(assigns(:receiver)).to be_nil
      end
    end
  end
end
