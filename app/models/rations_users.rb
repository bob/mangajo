class RationsUsers < ActiveRecord::Base
  def change
    create_table :rations_users do |t|
      t.belongs_to :ration
      t.belongs_to :user
    end
  end
end
