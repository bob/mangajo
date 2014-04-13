class AddMealsNumToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :meals_num, :integer, :default => 1
  end
end
