require 'spec_helper'

describe Dish do
  describe "Associations" do
    it { should have_many(:dish_compositions).dependent(:destroy) }
    it { should have_many(:ingredients) }
    it { should have_many(:eatens) }

  end

  describe "Scopes" do
    it "should get by ration" do
      ration = Factory.create(:ration)
      ration_2 = Factory.create(:ration)
      ingredient_a = Factory.create(:ingredient, :ration => ration)
      ingredient_b = Factory.create(:ingredient, :ration => ration)
      ingredient_2 = Factory.create(:ingredient, :ration => ration_2)
      dish_1 = Factory.create(:dish)

      dish_2 = Factory.create(:dish)
      dish_2.ingredients.delete_all

      dc_a = Factory.create(:dish_composition, :ingredient => ingredient_a, :dish => dish_1)
      dc_b = Factory.create(:dish_composition, :ingredient => ingredient_b, :dish => dish_1)

      dc_2 = Factory.create(:dish_composition, :ingredient => ingredient_2, :dish => dish_2)

      res = Dish.by_ration(ration.id)
      res.should == [dish_1]
    end
  end

  describe "Ingredients" do
    it "should be valid" do
      dish = Factory.create(:dish)
      dish.should be_valid
    end

    it "should be invalid without ingredients" do
      dish = Factory.create(:dish)
      dish.dish_compositions = []

      dish.ingredients.count.should == 0
      dish.should_not be_valid
    end

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
