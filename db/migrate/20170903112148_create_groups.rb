class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :photo_url
      t.string :code, null: false
      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.timestamps

      t.index :code, unique: true
    end
  end
end
