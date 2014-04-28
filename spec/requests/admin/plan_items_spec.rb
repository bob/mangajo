require 'spec_helper'

describe "Plan" do
  include DishHelper

  let(:user) { create(:user) }

  before(:each) do
    user.add_rations
    login_as user
  end

  describe "Add new" do
    it "should add existing ingredient" do
      plan = create(:plan, :user => user)
      ingredient = create(:ingredient, :user => user, :ration => Ration.find(user.setting(:ration)))

      visit new_admin_plan_plan_item_path(plan, :meal_id => 1)

      select ingredient.name, :from => "plan_item_ingredient_id"
      click_button "Create Plan item"

      current_path.should == admin_plan_path(plan)
      page.should have_selector("div.panel_contents div.column a", ingredient.name)
    end

    it "should add created ingredient" do
      plan = create(:plan, :user => user)
      ingredient = build(:ingredient)

      visit new_admin_plan_plan_item_path(plan, :meal_id => 1)
      click_link("Create ingredient")
      current_path.should == new_admin_ingredient_path

      fill_in "ingredient_name", :with => ingredient.name
      fill_in "ingredient_portion", :with => ingredient.portion
      click_button("Create Ingredient")

      current_path.should == new_admin_plan_plan_item_path(plan)

      select ingredient.name, :from => "plan_item_ingredient_id"
      click_button "Create Plan item"

      current_path.should == admin_plan_path(plan)
      page.should have_selector("div.panel_contents div.column a", ingredient.name)
    end

    it "should add copied ingredient" do
      default_ration = Ration.get_default
      plan = create(:plan, :user => user)
      ingredient = create(:ingredient, :ration => default_ration, :user => create(:user))

      visit new_admin_plan_plan_item_path(plan, :meal_id => 1)
      click_link("Create ingredient")
      current_path.should == new_admin_ingredient_path

      find("span.action_item a", :text => "Rations").click # goto rations list
      click_link default_ration.name # goto to ingredients list
      click_link ingredient.name # select ingredient
      click_button("Update Ingredient")

      current_path.should == new_admin_plan_plan_item_path(plan)

      select ingredient.name, :from => "plan_item_ingredient_id"
      click_button "Create Plan item"

      current_path.should == admin_plan_path(plan)
      page.should have_selector("div.panel_contents div.column a", ingredient.name)
    end
  end
end
