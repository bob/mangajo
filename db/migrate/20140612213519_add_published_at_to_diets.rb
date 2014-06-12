class AddPublishedAtToDiets < ActiveRecord::Migration
  def change
    add_column :diets, :published_at, :datetime
  end
end
