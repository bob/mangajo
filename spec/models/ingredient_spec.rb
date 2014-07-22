require 'spec_helper'

describe Ingredient do
  it "should calculate nutrient weight" do
    ingredient = create(:ingredient, :portion => 100, :portion_unit => "gramm", :proteins => 55)
    ingredient.calculate_nutrient_weight(:proteins, 180).should == 99
  end

  context "List" do
    it "should be for available rations" do
      first = create(:user)
      second = create(:user)

      own_ration = create(:ration, :user => first)
      shared_ration = create(:ration, :user => second)
      first.shared_rations << shared_ration
      alien_ration = create(:ration, :user => second)

      ingredient1 = create(:ingredient, :ration => own_ration)
      ingredient2 = create(:ingredient, :ration => shared_ration)
      ingredient3 = create(:ingredient, :ration => alien_ration)

      list = Ingredient.by_available_rations(first)

      list.should include(ingredient1)
      list.should include(ingredient2)
      list.should_not include(ingredient3)
    end


  end
end
