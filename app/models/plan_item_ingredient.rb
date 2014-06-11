class PlanItemIngredient < ActiveRecord::Base
  include Copier

  belongs_to :plan_item
  belongs_to :ingredient

  attr_accessible :weight, :portion

  def display_name
    ingredient.name
  end

  def portion
    self.ingredient.portion.present? ? (self.weight / self.ingredient.portion) : 0
  end

  def portion=(value)
    self.weight = self.ingredient.weight.to_f * value.to_f
  end
end
