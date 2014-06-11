class CreateDiets < ActiveRecord::Migration
  def change
    create_table :diets do |t|
      t.integer :user_id, :null => false
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
