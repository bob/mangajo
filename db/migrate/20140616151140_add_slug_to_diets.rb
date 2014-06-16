class AddSlugToDiets < ActiveRecord::Migration
  def change
    add_column :diets, :slug, :string
    add_index :diets, :slug
  end
end
