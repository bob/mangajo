class AddUserIdToEatens < ActiveRecord::Migration
  def change
    add_column :eatens, :user_id, :integer
  end
end
