class CreatePlanItems < ActiveRecord::Migration
  def change
    create_table :plan_items do |t|
      t.integer :plan_id
      t.integer :dish_id
      t.integer :meal_id
      t.float :weight, :default => 0

      t.timestamps
    end
  end
end
