class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :sender, foreign_key: {to_table: :users}
      t.references :group, null: true, foreign_key: true
      t.references :receiver, null: true, foreign_key: {to_table: :users}
      t.text :content
      t.timestamps
    end
  end
end
