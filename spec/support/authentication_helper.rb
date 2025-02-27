module AuthenticationHelper
  def sign_in(user)
    session = user.sessions.create!(user_agent: "RSpec Test", ip_address: "127.0.0.1")
    cookies.signed[:session_id] = session.id
  end

  def sign_out
    cookies.delete(:session_id)
  end
end
