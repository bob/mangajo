class DishComposition < ActiveRecord::Base
  attr_accessible :dish_id, :ingredient_id, :weight

  belongs_to :dish
  belongs_to :ingredient
end
