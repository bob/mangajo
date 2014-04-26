class IngredientGroup < ActiveRecord::Base
  default_scope { order(:name) }
  has_many :ingredients

end
