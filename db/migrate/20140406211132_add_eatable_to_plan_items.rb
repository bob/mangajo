class AddEatableToPlanItems < ActiveRecord::Migration
  def change
    rename_column :plan_items, :dish_id, :eatable_id
    add_column :plan_items, :eatable_type, :string, :default => "Dish", :after => :eatable_id
  end
end
