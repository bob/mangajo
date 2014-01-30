class PlanItem < ActiveRecord::Base
  belongs_to :plan
  belongs_to :dish
  belongs_to :meal
  has_many :plan_item_ingredients, :dependent => :destroy
  has_many :ingredients, :through => :plan_item_ingredients

  attr_accessible :plan_id, :dish_id, :meal_id, :weight

  validates :plan, :dish, :meal, :presence => true

  after_create :add_ingredients

  def add_ingredients
    self.dish.ingredients.each do |ingredient|
      self.ingredients << ingredient
    end
  end

  def calculate_nutrient_weight(nutrient, weight)
    sum = 0
    self.plan_item_ingredients.each do |piing|
      sum += piing.ingredient.calculate_nutrient_weight(nutrient, piing.weight)
    end
    sum
  end

  def pi_ingredients_with_protein
    self.plan_item_ingredients.select{|i| i.ingredient.proteins > 0}
  end

  def pi_ingredients_without_protein
    self.plan_item_ingredients.select{|i| i.ingredient.proteins <= 0}
  end

  def ingredients_percentage
    res = {}
    self.plan_item_ingredients.each do |piing|
      res[piing.id] = (self.dish.dish_compositions.find_by_ingredient_id(piing.ingredient_id).weight.to_f * 100 / self.dish.weight).round(2)
    end
    res
  end

  def ingredients_with_protein_percentage
    weights = {}
    self.pi_ingredients_with_protein.each do |piing|
      weights[piing.id] = self.dish.dish_compositions.find_by_ingredient_id(piing.ingredient_id).weight.to_f
    end

    res = {}
    self.pi_ingredients_with_protein.each do |piing|
      res[piing.id] = (weights[piing.id] * 100 / weights.values.sum).round(2)
    end
    res
  end

end
