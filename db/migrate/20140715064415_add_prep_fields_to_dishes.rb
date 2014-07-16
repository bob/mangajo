class AddPrepFieldsToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :prep_time, :integer, :default => 0
    add_column :dishes, :cook_time, :integer, :default => 0
    add_column :dishes, :portions, :integer, :default => 0
  end
end
