class CreateDietItems < ActiveRecord::Migration
  def change
    create_table :diet_items do |t|
      t.integer :diet_id, :null => false
      t.integer :plan_id, :null => false
      t.integer :order_num

      t.timestamps
    end
  end
end
