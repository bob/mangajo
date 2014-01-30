require 'spec_helper'

describe Dish do
  describe "Associations" do
    it { should have_many(:dish_compositions).dependent(:destroy) }
    it { should have_many(:ingredients) }
    it { should have_many(:eatens) }

  end

  describe "Ingredients" do
    it "should calculate params" do
      dish = Factory.create(:dish_schema_a)
      dish_sample = Factory.build(:dish_sample)

      dish.name.should be_present

      dish.calculate_params
      dish.weight.should == dish_sample.weight
      dish.proteins.should == dish_sample.proteins
      dish.fats.should == dish_sample.fats
      dish.carbs.should == dish_sample.carbs
    end

  end
end
