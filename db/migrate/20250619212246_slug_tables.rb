# frozen_string_literal: true

class SlugTables < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :slug, :string
    add_index :groups, :slug, unique: true

    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
  end
end
