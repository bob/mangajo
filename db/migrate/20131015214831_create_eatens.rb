class CreateEatens < ActiveRecord::Migration
  def change
    create_table :eatens do |t|
      t.integer :eatable_id
      t.string :eatable_type
      t.integer :weight, :default => 0
      t.float :proteins, :default => 0
      t.float :fats, :default => 0
      t.float :carbs, :default => 0

      t.timestamps
    end
  end
end
