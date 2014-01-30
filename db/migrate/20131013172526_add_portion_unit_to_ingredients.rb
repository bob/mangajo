class AddPortionUnitToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :portion_unit, :string, :after => :portion
  end
end
