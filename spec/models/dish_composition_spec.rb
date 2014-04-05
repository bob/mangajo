require 'spec_helper'

describe DishComposition do
  describe "Associations" do
    it { should belong_to(:dish) }
    it { should belong_to(:ingredient) }
  end

  describe "Calculations" do
    let(:dish) { Factory.create(:dish) }
    let(:ingredient) { Factory.create(:ingredient, :portion_unit => "item", :portion => 55) }

    it "should calc weight for portion" do
      dc = DishComposition.new
      dc.dish = dish
      dc.ingredient = ingredient
      dc.portions = 3
      dc.weight = 100

      dc.save.should be_true

      dc.reload
      dc.weight.should eq 165
    end

    it "should not calc" do
      ingredient = Factory.create(:ingredient, :portion_unit => "gramm", :portion => 55)

      dc = DishComposition.new
      dc.dish = dish
      dc.ingredient = ingredient
      dc.portions = 3
      dc.weight = 100

      dc.save.should be_true

      dc.reload
      dc.weight.should eq 100
    end
  end
end
