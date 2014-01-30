class CreatePlanItemIngredients < ActiveRecord::Migration
  def change
    create_table :plan_item_ingredients do |t|
      t.integer :plan_item_id
      t.integer :ingredient_id
      t.float :weight, :default => 0

      t.timestamps
    end
  end
end
