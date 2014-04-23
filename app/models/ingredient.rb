class Ingredient < ActiveRecord::Base
  include Calorie
  attr_accessible :name, :portion, :portion_unit, :carbs, :fats, :proteins

  has_many :dish_compositions, :dependent => :restrict_with_exception
  has_many :dishes, :through => :dish_compositions
  has_many :eatens, :as => :eatable
  has_many :plan_items, :dependent => :destroy, :as => :eatable
  has_many :plan_item_ingredients, :dependent => :destroy
  belongs_to :ration
  belongs_to :user

  scope :by_ration, ->(ration_id) { where(:ration_id => ration_id)}

  PORTION_UNITS = {:gramm => "g", :item => "item", :teaspoon => "t.s."}

  validates_presence_of :name, :portion, :portion_unit

  after_initialize :after_init
  after_update :recalculate_dependencies

  def after_init
    self.portion_unit ||= PORTION_UNITS.invert["g"]
  end

  def recalculate_dependencies
    if portion_changed? or carbs_changed? or fats_changed? or proteins_changed?
      # calls order below is important
      self.dish_compositions.each { |dc| dc.save }
      self.dishes.each{ |d| d.save }
    end
  end

  def weight
    self.portion
  end

  def calculate_nutrient_weight(nutrient, weight)
    weight ||= 0
    n = self.send(nutrient) || 0
    case self.portion_unit
    when "gramm"
      weight * n / self.portion
    when "item"
      #p "WEIGHT: #{weight}, #{nutrient}: #{self.send(nutrient)}, PORTION: #{self.portion}"
      weight * n / self.portion
    else
      0
    end
  end

  def self.by_ration_and_own(ration_id, user = nil)
    ration = Ration.find(ration_id)
    user ||= ration.user

    #self.where("ration_id = ? OR (ration_id = ? AND user_id = ?)", ration.id, ration.id, user.id)
    self.where("ration_id = ? AND user_id = ?", ration.id, user.id)
    .order("ingredients.created_at DESC")
  end

end
