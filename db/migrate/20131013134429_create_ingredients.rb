class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.integer :portion
      t.float :carbs
      t.float :fats
      t.float :proteins

      t.timestamps
    end
  end
end
