class AddUserIdToDishes < ActiveRecord::Migration
  def migrate(direction)
    super

    if direction == :up
      admin = User.find(1)
      if admin
        Dish.all.each { |d| d.update_column(:user_id, admin.id) }
      end
    end
  end

  def change
    add_column :dishes, :user_id, :integer
  end
end
