class SeedSharedDefaultRation < ActiveRecord::Migration
  def change
    default_ration = Ration.find 1
    if default_ration
      User.all.each do |user|
        next if user.rations.include? default_ration
        default_ration.customers << user
      end
      default_ration.save
    end
  end
end
