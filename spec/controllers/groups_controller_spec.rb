require "rails_helper"
RSpec.describe GroupsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { {name: "Test Group"} }
  let(:invalid_attributes) { {name: ""} }

  before do
    sign_in user
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new group" do
        expect {
          post :create, params: {group: valid_attributes}
        }.to change(Group, :count).by(1)
      end

      it "associates the group with the current user" do
        post :create, params: {group: valid_attributes}
        expect(user.groups.last.name).to eq("Test Group")
      end

      it "redirects to the root path with a notice" do
        post :create, params: {group: valid_attributes}
        expect(response).to redirect_to(root_path(group_id: assigns(:group).id))
        expect(flash[:notice]).to eq("Group created successfully.")
      end
    end

    context "with invalid attributes" do
      it "does not create a new group" do
        expect {
          post :create, params: {group: invalid_attributes}
        }.to_not change(Group, :count)
      end

      it "redirects to the root path with an alert" do
        post :create, params: {group: invalid_attributes}
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Name can't be blank")
      end
    end
  end
end
