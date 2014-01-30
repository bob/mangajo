class CreateDishCompositions < ActiveRecord::Migration
  def change
    create_table :dish_compositions do |t|
      t.integer :dish_id
      t.integer :ingredient_id
      t.integer :weight

      t.timestamps
    end
  end
end
