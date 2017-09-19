class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships do |t|
      t.references :group, foreign_key: { to_table: :groups }, null: false
      t.references :user, foreign_key: { to_table: :users }, null: false
      t.timestamps
      t.index [:group_id, :user_id], unique: true
    end
  end
end
