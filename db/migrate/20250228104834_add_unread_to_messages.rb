class AddUnreadToMessages < ActiveRecord::Migration[8.0]
  def change
    change_table :messages do |t|
      t.boolean :unread, default: true
    end
  end
end
