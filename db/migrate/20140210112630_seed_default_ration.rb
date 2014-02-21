class SeedDefaultRation < ActiveRecord::Migration
  def migrate(direction)
    super

    if direction == :up
      admin = User.find(1)

      if admin
        default_ration = Ration.new(:name => "Default", :description => "Default ration")
        default_ration.user = admin
        default_ration.save
      end

      if default_ration
        execute("UPDATE ingredients SET ration_id = ?", default_ration.id)
      end
    end

  end

  def change
    add_column :ingredients, :ration_id, :integer
  end
end
