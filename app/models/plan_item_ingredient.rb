class PlanItemIngredient < ActiveRecord::Base
  belongs_to :plan_item
  belongs_to :ingredient

  attr_accessible :weight
end
