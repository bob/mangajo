class Eaten < ActiveRecord::Base
  attr_accessible :weight, :eatable_id, :eatable_type

  belongs_to :eatable, :polymorphic => true
  belongs_to :user

  after_save :after_saved

  def after_saved
    eated = self.eatable
    self.update_column(:proteins, eated.calculate_nutrient_weight(:proteins, self.weight))
    self.update_column(:fats, eated.calculate_nutrient_weight(:fats, self.weight))
    self.update_column(:carbs, eated.calculate_nutrient_weight(:carbs, self.weight))
  end

  class << self
    def find_day(date=nil)
      db_date = date ? date.to_date : Date.today.to_date
      where("created_at <= '#{db_date.end_of_day}' AND created_at >= '#{db_date.beginning_of_day}'")
    end
  end
end
