# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::RegistrationsController", type: :request do
  describe "POST #create" do
    let!(:valid_params) do
      {
        user: attributes_for(:user)
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        expect do
          post api_sign_up_path, params: valid_params
        end.to change(User, :count).by(1)
      end

      it "returns a JSON response with the new user" do
        post api_sign_up_path, params: valid_params
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("user")
        expect(json_response).to have_key("token")
      end
    end

    context "with invalid parameters" do
      let!(:invalid_params) do
        {
          user: attributes_for(:user, email_address: "invalid-email")
        }
      end

      it "does not create a new user" do
        expect do
          post api_sign_up_path, params: invalid_params
        end.not_to change(User, :count)
      end

      it "returns a JSON response with errors" do
        post api_sign_up_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
