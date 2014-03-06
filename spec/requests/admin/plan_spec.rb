require 'spec_helper'

describe "Plan" do
  let(:user) { Factory.create(:user) }

  before(:each) do
    login_as user
    Factory.create(:ration, :id => 1)
  end

  describe "Manage" do
    it "should add a dish" do
      plan = Factory.create(:plan, :user => user)
      dish = Factory.create(:dish, :user => user)

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
