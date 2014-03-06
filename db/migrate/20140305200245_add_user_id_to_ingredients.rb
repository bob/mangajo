class AddUserIdToIngredients < ActiveRecord::Migration
  def migrate(direction)
    super

    if direction == :up
      Ingredient.all.each do |i|
        i.update_column(:user_id, i.ration.user.id)
      end
    end
  end

  def change
    add_column :ingredients, :user_id, :integer
  end
end
