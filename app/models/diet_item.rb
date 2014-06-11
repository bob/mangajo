class DietItem < ActiveRecord::Base
  belongs_to :plan
  belongs_to :diet

  attr_accessible :plan_id, :diet_id, :order_num

  validates :plan, :diet, :presence => true
end
