class CreateRations < ActiveRecord::Migration
  def change
    create_table :rations do |t|
      t.integer :user_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
