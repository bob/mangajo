class Ingredient < ActiveRecord::Base
  include Calorie
  attr_accessible :name, :portion, :portion_unit, :carbs, :fats, :proteins

  has_many :dish_compositions, :dependent => :restrict_with_exception
  has_many :dishes, :through => :dish_compositions
  has_many :eatens, :as => :eatable
  has_many :plan_item_ingredients, :dependent => :destroy
  belongs_to :ration
  belongs_to :user

  scope :by_ration, ->(ration_id) { where(:ration_id => ration_id)}

  PORTION_UNITS = {:gramm => "g", :item => "item", :teaspoon => "t.s."}

  validates_presence_of :name, :portion, :portion_unit
  after_initialize :after_init

  def after_init
    self.portion_unit ||= PORTION_UNITS.invert["g"]
  end

  def self.by_ration_and_own(ration_id, user = nil)
    ration = Ration.find(ration_id)
    user ||= ration.user

    self.where("ration_id = ? OR (ration_id = ? AND user_id = ?)", ration.id, ration.id, user.id)
    .order("ingredients.created_at DESC")
  end

  def calculate_nutrient_weight(nutrient, weight)
    weight ||= 0
    case self.portion_unit
    when "gramm"
      weight * self.send(nutrient) / self.portion
    when "item"
      weight * self.send(nutrient) / self.portion
    else
      0
    end
  end
end
