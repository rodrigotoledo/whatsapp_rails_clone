class GroupsUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :groups_users, id: false do |t|
      t.references :group
      t.references :user
    end
  end
end
