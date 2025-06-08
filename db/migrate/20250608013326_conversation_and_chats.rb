class ConversationAndChats < ActiveRecord::Migration[8.0]
  def up
    # Criação da tabela de conversas com foreign keys
    create_table :conversations do |t|
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }
      t.datetime :last_message_at
      t.timestamps

      t.index [ :user1_id, :user2_id ], unique: true
      t.index [ :user2_id, :user1_id ], unique: true
    end

    add_column :messages, :messageable_type, :string
    add_column :messages, :messageable_id, :integer
    add_index :messages, [ :messageable_type, :messageable_id ], name: "index_messages_on_messageable"

    remove_column :messages, :receiver_id
    remove_column :messages, :group_id
  end

  def down
    add_column :messages, :receiver_id, :integer
    add_column :messages, :group_id, :integer

    remove_column :messages, :messageable_type
    remove_column :messages, :messageable_id

    drop_table :conversations
  end
end
