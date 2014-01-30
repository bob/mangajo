require 'spec_helper'

describe Ingredient do
  it "should calculate nutrient weight" do
    ingredient = Factory.create(:ingredient, :portion => 100, :portion_unit => "gramm", :proteins => 55)
    ingredient.calculate_nutrient_weight(:proteins, 180).should == 99
  end
end
