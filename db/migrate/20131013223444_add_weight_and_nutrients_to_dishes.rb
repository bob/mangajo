class AddWeightAndNutrientsToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :proteins, :float
    add_column :dishes, :fats, :float
    add_column :dishes, :carbs, :float
    add_column :dishes, :weight, :integer
  end
end
