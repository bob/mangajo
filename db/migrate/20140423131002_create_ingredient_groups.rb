class CreateIngredientGroups < ActiveRecord::Migration
  def change
    create_table :ingredient_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
