class Ration < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients

  attr_accessible :name, :description

  validate :name, :presence => true
end
