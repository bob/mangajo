class Dish < ActiveRecord::Base
  include Calorie
  attr_accessible :name, :description, :dish_compositions_attributes

  has_many :dish_compositions, :dependent => :destroy
  has_many :ingredients, :through => :dish_compositions
  has_many :eatens, :as => :eatable
  has_many :plan_items, :dependent => :destroy, :as => :eatable
  belongs_to :user
  has_one :post, :as => :postable, :dependent => :destroy

  #scope :by_ration, ->(ration_id) { includes(:ingredients).where(:ingredients => {:ration_id => ration_id }).order("dishes.created_at DESC") }

  accepts_nested_attributes_for :dish_compositions, :allow_destroy => true

  validates :name, :presence => true
  validate :validate_ingredients

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

  def self.by_ration_and_own(ration_id, user = nil)
    ration = Ration.find(ration_id)
    user ||= ration.user

    self.includes(:ingredients)
    .where(:ingredients => {:ration_id => ration_id })
    .where("dishes.user_id = ? OR dishes.user_id = ?", ration.user_id, user.id)
    .order("dishes.created_at DESC")
  end

  def validate_ingredients
    unless dish_compositions.present?
      errors.add(:base, "At least one ingredient should be defined")
    end
  end

  def calculate_params
    self.weight = 0
    self.proteins = 0
    self.fats = 0
    self.carbs = 0

    dish_compositions.each do |dc|
      self.weight += dc.weight || 0
      self.proteins += dc.proteins
      #p "PROTEINS: #{self.proteins}"
      self.fats += dc.fats
      self.carbs += dc.carbs
    end
  end

  def calculate_nutrient_weight(nutrient, weight_in)
    return 0 if self.weight.to_i == 0
    weight_in.to_i * self.send(nutrient) / self.weight.to_i
  end

  def published_at
    updated_at
  end

end
