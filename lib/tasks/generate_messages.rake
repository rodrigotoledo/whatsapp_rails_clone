# frozen_string_literal: true

# lib/tasks/generate_messages.rake
namespace :db do
  desc "Generate mass messages between admin and existing users"
  task generate_mass_messages: :environment do
    puts "Iniciando geração de mensagens em massa..."

    # Encontra ou cria o admin
    admin = User.find_by(email_address: "admin@example.com")

    # Pega todos os usuários existentes (exceto admin)
    users = User.where.not(id: admin.id).to_a

    if users.empty?
      puts "Nenhum usuário encontrado. Criando 5 usuários de exemplo..."
      5.times do |i|
        users << User.create!(
          email_address: "user#{i+1}@example.com",
          password: "password123",
          password_confirmation: "password123"
        )
      end
    end

    # Gera mensagens para cada usuário
    users.each do |user|
      # Encontra ou cria conversa direta
      conversation = Conversation.direct_between(admin, user).first_or_create!(
        conversation_type: "direct"
      )

      # Garante que ambos são participantes
      [ admin, user ].each do |participant|
        ConversationParticipant.find_or_create_by!(
          conversation: conversation,
          user: participant
        )
      end

      # Gera um grande número de mensagens (100 por conversa)
      puts "Gerando mensagens entre admin e #{user.email_address}..."
      100.times do |i|
        sender = rand(3) == 0 ? admin : user # 33% de chance de ser admin
        created_at = rand(1..365).days.ago

        Message.create!(
          conversation: conversation,
          sender: sender,
          content: Faker::Lorem.paragraph(sentence_count: rand(1..3)),
          created_at: created_at
        )

        # Atualiza last_read_at aleatoriamente
        if rand(5) == 0 # 20% de chance
          ConversationParticipant.where(
            conversation: conversation,
            user: [ admin, user ].sample
          ).update_all(last_read_at: created_at + rand(10).minutes)
        end
      end
    end

    # Gera mensagens em grupos existentes (se houver)
    Group.find_each do |group|
      conversation = group.conversation
      next unless conversation

      puts "Gerando mensagens para o grupo #{group.name}..."
      participants = group.users.to_a

      150.times do |i|
        sender = participants.sample
        created_at = rand(1..365).days.ago

        Message.create!(
          conversation: conversation,
          sender: sender,
          content: "[GRUPO] #{Faker::Lorem.paragraph(sentence_count: rand(1..3))}",
          created_at: created_at
        )
      end
    end

    puts "Geração de mensagens concluída com sucesso!"
    puts "Total de mensagens geradas: #{Message.count}"
  end
end
