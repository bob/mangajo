class Diet < ActiveRecord::Base
  attr_accessible :name, :description, :diet_items_attributes

  has_many :diet_items
  accepts_nested_attributes_for :diet_items, :allow_destroy => true
end
