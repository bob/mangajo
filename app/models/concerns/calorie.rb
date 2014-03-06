module Calorie
  extend ActiveSupport::Concern

  included do
  end

  def kcal
    Calorie.calculate(self.proteins, self.fats, self.carbs).round(2)
  end

  def calculate_kcal_weight(weight)
    Calorie.calculate(
      calculate_nutrient_weight(:proteins, weight),
      calculate_nutrient_weight(:fats, weight),
      calculate_nutrient_weight(:carbs, weight)
    ).round(2)
  end

  def self.calculate(proteins, fats, carbs)
    ((proteins || 0) * 4 + (carbs || 0) * 4 + (fats || 0) * 9)
  end


end
