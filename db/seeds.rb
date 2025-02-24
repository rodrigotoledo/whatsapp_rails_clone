user = User.create!(email_address: "faker@test.com", password: "password", password_confirmation: "password")

10.times do
  User.create!(email_address: Faker::Internet.email, password: "password", password_confirmation: "password")
end

User.order(id: :desc).limit(3).each do |friend|
  user.friends << friend
end
