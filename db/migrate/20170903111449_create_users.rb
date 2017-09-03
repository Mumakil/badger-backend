class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :fbid, null: false
      t.string :avatar_url, null: false
      t.timestamps
      t.index :fbid, unique: true
    end
  end
end
