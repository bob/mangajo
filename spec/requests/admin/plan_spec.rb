require 'spec_helper'

describe "Plan" do
  include DishHelper

  let(:user) { create(:user) }

  before(:each) do
    ration = create(:ration, :user => user)
    ration_setting = create(:setting, :var => "ration", :value => ration.id)
    user.settings << ration_setting
    login_as user
  end

  describe "Manage" do
    it "should add a dish" do
      plan = create(:plan, :user => user)
      dish = create_dish_user_ration(:dish, user)

      visit admin_plan_path(plan)

      page.should have_selector("h2#page_title", plan.name)
      within("div.panel h3", :match => :first) do
        click_link "Add"
      end

      page.should have_selector("h2#page_title", "New Plan Item")
      select(dish.name, :from => "Dish")
      click_button "Create Plan item"

      page.should have_selector("h2#page_title", plan.name)
      page.should have_selector("div.panel_contents a", dish.name)
    end

  end
end
