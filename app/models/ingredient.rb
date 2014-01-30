class Ingredient < ActiveRecord::Base
  attr_accessible :name, :portion, :portion_unit, :carbs, :fats, :proteins

  has_many :dish_compositions, :dependent => :restrict_with_exception
  has_many :dishes, :through => :dish_compositions
  has_many :eatens, :as => :eatable
  has_many :plan_item_ingredients, :dependent => :destroy

  PORTION_UNITS = {:gramm => "g", :item => "item", :teaspoon => "t.s."}

  validates_presence_of :name, :portion, :portion_unit
  after_initialize :after_init

  def after_init
    self.portion_unit ||= PORTION_UNITS.invert["g"]
  end

  def calculate_nutrient_weight(nutrient, weight)
    case self.portion_unit
    when "gramm"
      weight * self.send(nutrient) / self.portion
    else
      0
    end
  end
end
