class AddGroupIdToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :ingredient_group_id, :integer, :default => 0
  end
end
