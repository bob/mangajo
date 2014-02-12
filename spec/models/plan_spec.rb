require 'spec_helper'

describe Plan do
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:plan_items) }
  end

  describe "Auto weights" do
    let(:user) { Factory.create(:user) }

    before(:each) do
      user.settings << Factory.create(:setting, :var => "meals", :value => 3)
      user.settings << Factory.create(:setting, :var => "proteins", :value => 140)
    end

    it "should calculate one dish, all ingredients with protein" do

      dish = Factory.create(:flakes)

      ing_1 = Factory.create(:nestle_fitness)
      ing_2 = Factory.create(:milk)
      dish_com_1 = Factory.create(:dish_composition, :weight => 80, :dish => dish, :ingredient => ing_1)
      dish_com_2 = Factory.create(:dish_composition, :weight => 15, :dish => dish, :ingredient => ing_2)

      plan = Factory.create(:plan_second, :user => user)
      plan_item_1 = Factory.create(:plan_item, :meal_id => 1, :plan => plan, :dish => dish, :weight => 0)
      piing_1 = Factory.create(:plan_item_ingredient, :plan_item => plan_item_1, :ingredient => ing_1, :weight => 0)
      piing_2 = Factory.create(:plan_item_ingredient, :plan_item => plan_item_1, :ingredient => ing_2, :weight => 0)

      plan.auto_weights!

      piing_1.reload; piing_2.reload
      piing_1.weight.round(2).should == 426.14
      piing_2.weight.round(2).should == 236.79
    end

    context "ingredients with zero protein" do
      before(:each) do
        @dish = Factory.create(:omelet)
        # this is because there is one ingredient by default and weight changed after save
        @dish.ingredients.delete_all
        @dish.update_column(:weight, 158)

        @ing_1 = Factory.create(:glair)
        @ing_2 = Factory.create(:salt)
        @ing_3 = Factory.create(:cheese)
        @ing_4 = Factory.create(:sugar)
        @dish_com_1 = Factory.create(:dish_composition, :weight => 91, :dish => @dish, :ingredient => @ing_1)
        @dish_com_2 = Factory.create(:dish_composition, :weight => 5, :dish => @dish, :ingredient => @ing_2)
        @dish_com_3 = Factory.create(:dish_composition, :weight => 50, :dish => @dish, :ingredient => @ing_3)
        @dish_com_4 = Factory.create(:dish_composition, :weight => 12, :dish => @dish, :ingredient => @ing_4)

        @plan = Factory.create(:plan_second, :user => user)
        @plan_item_1 = Factory.create(:plan_item, :meal_id => 1, :plan => @plan, :dish => @dish, :weight => 0)
        @piing_1 = Factory.create(:plan_item_ingredient, :plan_item => @plan_item_1, :ingredient => @ing_1, :weight => 0)
        @piing_2 = Factory.create(:plan_item_ingredient, :plan_item => @plan_item_1, :ingredient => @ing_2, :weight => 0)
        @piing_3 = Factory.create(:plan_item_ingredient, :plan_item => @plan_item_1, :ingredient => @ing_3, :weight => 0)
        @piing_4 = Factory.create(:plan_item_ingredient, :plan_item => @plan_item_1, :ingredient => @ing_4, :weight => 0)
      end

      it "select ingredients with protein" do
        @plan_item_1.pi_ingredients_with_protein.should == [@piing_1, @piing_3]
      end

      it "select ingredients without protein" do
        @plan_item_1.pi_ingredients_without_protein.should include(@piing_2, @piing_4)
        @plan_item_1.pi_ingredients_without_protein.should_not include(@piing_1, @piing_3)
      end

      it "all ingredients percentage" do
        a = @plan_item_1.ingredients_percentage
        a[@piing_1.id].should == 57.59
        a[@piing_2.id].should == 3.16
        a[@piing_3.id].should == 31.65
        a[@piing_4.id].should == 7.59
      end

      it "ingredients with protein percentage" do
        a = @plan_item_1.ingredients_with_protein_percentage
        a.count.should == 2
        a[@piing_1.id].should == 64.54
        a[@piing_3.id].should == 35.46
      end

      it "weights auto calculating" do
        @plan.auto_weights!

        @piing_1.reload; @piing_2.reload; @piing_3.reload; @piing_4.reload
        @piing_1.weight.round(2).should == 213.46
        @piing_2.weight.round(2).should == 9.84
        @piing_3.weight.round(2).should == 64.18
        @piing_4.weight.round(2).should == 23.64

      end

    end
  end
end
