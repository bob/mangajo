class CreateRationsUsers < ActiveRecord::Migration
  def change
    create_table :rations_users do |t|
      t.integer :ration_id
      t.integer :user_id

      t.timestamps
    end
  end
end
