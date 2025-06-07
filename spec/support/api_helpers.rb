# frozen_string_literal: true

module ApiSessionHelpers
  def generate_jwt_token(user)
    { Authorization: bearer_token(user) }
  end

  def generate_invalid_jwt_token
    { Authorization: bearer_token }
  end

  def bearer_token(user = nil)
    payload = { user_id: user.try(:id) }
    token = encode_token(payload)
    "Bearer #{token}"
  end

  def encode_token(payload)
    JWT.encode(payload, ENV.fetch("JWT_KEY", nil))
  end

  def sign_in(user, password = PASSWORD_FOR_USER)
    post api_sign_in_path, params: { email_address: user.email_address, password: password }
    JSON.parse(response.body)
  end

  def logout(user)
    delete api_logout_path, headers: generate_jwt_token(user), headers: { "CONTENT_TYPE" => "application/json" }
  end
end
