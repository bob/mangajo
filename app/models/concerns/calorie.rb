module Calorie
  extend ActiveSupport::Concern

  included do
  end

  def kcal
    ((self.proteins || 0) * 4 + (self.carbs || 0) * 4 + (self.fats || 0) * 9).round(2)
  end


end
