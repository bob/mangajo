class Dish < ActiveRecord::Base
  attr_accessible :name, :description, :dish_compositions_attributes

  has_many :dish_compositions, :dependent => :destroy
  has_many :ingredients, :through => :dish_compositions
  has_many :eatens, :as => :eatable

  accepts_nested_attributes_for :dish_compositions, :allow_destroy => true

  after_save :after_saved

  def after_saved
    if ingredients.present?
      calculate_params
      self.update_column(:weight, self.weight)
      self.update_column(:proteins, self.proteins)
      self.update_column(:fats, self.fats)
      self.update_column(:carbs, self.carbs)
    end
  end

  def calculate_params
    self.weight = 0
    self.proteins = 0
    self.fats = 0
    self.carbs = 0

    dish_compositions.each do |dc|
      self.weight += dc.weight
      self.proteins += dc.ingredient.calculate_nutrient_weight(:proteins, dc.weight)
      self.fats += dc.ingredient.calculate_nutrient_weight(:fats, dc.weight)
      self.carbs += dc.ingredient.calculate_nutrient_weight(:carbs, dc.weight)
    end
  end

  def calculate_nutrient_weight(nutrient, weight_in)
    weight_in.to_i * self.send(nutrient) / self.weight.to_i
  end

end
