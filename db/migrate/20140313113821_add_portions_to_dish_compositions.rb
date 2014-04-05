class AddPortionsToDishCompositions < ActiveRecord::Migration
  def change
    add_column :dish_compositions, :portions, :integer, :default => 0
  end
end
