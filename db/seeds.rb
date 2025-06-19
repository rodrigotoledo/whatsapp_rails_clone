# frozen_string_literal: true

User.create!(email_address: "faker@test.com", password: "password", password_confirmation: "password")
# Cria o usuário principal (admin)
admin = User.create!(
  email_address: "admin@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Cria N usuários de teste (20 neste exemplo)
20.times do |i|
  user = User.create!(
    email_address: "user#{i+1}@example.com",
    password: "password123",
    password_confirmation: "password123"
  )

  # Cria amizade entre admin e o usuário atual
  Friendship.create!(
    user: admin,
    friend: user,
    status: "accepted"
  )

  # Cria conversa direta entre admin e o usuário
  conversation = Conversation.create!(
    conversation_type: "direct"
  )

  # Adiciona ambos como participantes
  ConversationParticipant.create!([
    { conversation: conversation, user: admin },
    { conversation: conversation, user: user }
  ])

  # Cria algumas mensagens de exemplo
  5.times do |j|
    sender = [ admin, user ].sample
    Message.create!(
      conversation: conversation,
      sender: sender,
      content: "Mensagem de exemplo #{j+1} de #{sender.email_address}",
      created_at: rand(1..30).days.ago
    )
  end

  # Marca algumas mensagens como lidas
  if i.even? # Para usuários pares, marca como lida
    ConversationParticipant.where(
      conversation: conversation,
      user: admin
    ).update(last_read_at: Time.current)
  end
end

# Cria alguns grupos
3.times do |i|
  group = Group.create!(name: "Grupo #{i+1}")

  # Adiciona admin e alguns usuários aleatórios ao grupo
  users_to_add = User.where.not(id: admin.id).sample(5) + [ admin ]
  group.users << users_to_add

  # Cria conversa de grupo
  group_conversation = Conversation.create!(
    conversation_type: "group",
    group: group
  )

  # Adiciona todos como participantes
  users_to_add.each do |user|
    ConversationParticipant.create!(
      conversation: group_conversation,
      user: user
    )
  end

  # Cria mensagens no grupo
  10.times do |j|
    sender = users_to_add.sample
    Message.create!(
      conversation: group_conversation,
      sender: sender,
      content: "Mensagem no grupo #{j+1} de #{sender.email_address}",
      created_at: rand(1..30).days.ago
    )
  end
end

puts "Seed concluído com sucesso!"
puts "Usuário admin: admin@example.com / password123"
puts "#{User.count} usuários criados"
puts "#{Friendship.count} amizades criadas"
puts "#{Conversation.count} conversas criadas"
puts "#{Message.count} mensagens criadas"
