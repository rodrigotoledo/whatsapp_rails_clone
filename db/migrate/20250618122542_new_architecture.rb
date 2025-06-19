# frozen_string_literal: true

class NewArchitecture < ActiveRecord::Migration[8.0]
  def up
    create_table "conversations", force: :cascade do |t|
      t.string "conversation_type", null: false # 'direct' ou 'group'
      t.timestamps
    end

    create_table "conversation_participants", force: :cascade do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime "last_read_at"
      t.timestamps
      t.index [ "conversation_id", "user_id" ], name: "index_conversation_participants_on_conversation_and_user", unique: true
    end

    drop_table :messages
    create_table "messages", force: :cascade do |t|
      t.references :conversation, null: false, foreign_key: true
      t.integer "sender_id", null: false
      t.text "content", null: false
      t.timestamps
      t.index [ "sender_id" ], name: "index_messages_on_sender_id"
    end

    # TODO: use this and not the last_read_at in conversation_participants
    # for each user in conversation participants should have a record here
    create_table "message_read_statuses", force: :cascade do |t|
      t.references :message, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime "read_at", null: true
      t.timestamps
      t.index [ "message_id", "user_id" ], name: "index_message_read_statuses_on_message_id_and_user_id", unique: true
    end

    create_table "groups", force: :cascade do |t|
      t.string "name"
      t.references :conversation, null: false, foreign_key: true
      t.timestamps
    end

    create_table "friendships", force: :cascade do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.string "status", default: "pending" # ou 'accepted', 'blocked'
      t.timestamps
    end
  end

  def down
    drop_table :friendships
    drop_table :groups
    drop_table :message_read_statuses
    drop_table :messages
    drop_table :conversation_participants
    drop_table :conversations
  end
end
