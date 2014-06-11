class PlanItem < ActiveRecord::Base
  include Calorie
  include Copier

  attr_accessible :plan_id, :meal_id, :weight, :eatable_id, :eatable_type

  attr_accessor :dish_id, :ingredient_id

  belongs_to :plan
  belongs_to :eatable, :polymorphic => true
  belongs_to :meal
  has_many :plan_item_ingredients, :dependent => :destroy
  has_many :ingredients, :through => :plan_item_ingredients

  validates :plan, :eatable, :meal, :presence => true

  after_create :add_ingredients, if: Proc.new { |obj| obj.plan_item_ingredients.empty? }

  def add_ingredients
    case self.eatable_type
    when "Dish"
      self.eatable.dish_compositions.each do |dc|
        pi = self.plan_item_ingredients.build(:weight => dc.weight)
        pi.ingredient = dc.ingredient
        pi.save
      end
    when "Ingredient"
      pi = self.plan_item_ingredients.build(:weight => eatable.weight)
      pi.ingredient = eatable
      pi.save
    else
    end
  end

  def do_copy
    wrap_copy do
      self.plan_item_ingredients.each do |i|
        new_item, message = i.do_copy
        new_item.ingredient_id = i.ingredient_id

        raise ActiveRecord::Rollback unless new_item
        @copied_item.plan_item_ingredients << new_item
      end
    end
  end

  def recalculate_weight
    weight = self.plan_item_ingredients.sum(:weight) rescue 0
    self.update_attribute(:weight, weight)
  end

  def update_ingredients
    self.plan_item_ingredients.destroy_all
    add_ingredients
  end

  def display_name
    eatable.name
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
    if eatable_type == "Dish"
      self.plan_item_ingredients.each do |piing|
        res[piing.id] = (self.eatable.dish_compositions.find_by_ingredient_id(piing.ingredient_id).weight.to_f * 100 / self.eatable.weight).round(2)
      end
    elsif eatable_type == "Ingredient"
      piing = self.plan_item_ingredients.first
      res[piing.id] = 100
    end
    res
  end

  def ingredients_with_protein_percentage
    weights = {}
    self.pi_ingredients_with_protein.each do |piing|
      if eatable_type == "Dish"
        weights[piing.id] = self.eatable.dish_compositions.find_by_ingredient_id(piing.ingredient_id).weight.to_f
      elsif eatable_type == "Ingredient"
        weights[piing.id] = self.eatable.weight
      end

    end

    res = {}
    self.pi_ingredients_with_protein.each do |piing|
      res[piing.id] = (weights[piing.id] * 100 / weights.values.sum).round(2)
    end
    res
  end

end
