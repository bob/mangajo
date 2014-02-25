require 'spec_helper'

describe "Dishes" do
  describe "Index" do
    let(:admin) { Factory.create(:user) }

    before(:each) do
      login_as admin
    end

    it "should contain own dishes and dishes from current ration" do
      own_dish = Factory.create(:dish, :user => admin)

      user_2 = Factory.create(:user)
      ration = Factory.create(:ration, :user => user_2)
      dish_2 = Factory.create(:dish, :user => user_2)
      dish_2.ingredients.each{ |i| i.update_column(:ration_id, ration.id) }
      own_dish.ingredients.each{ |i| i.update_column(:ration_id, ration.id) }
      admin.shared_rations << ration
      admin.settings << Factory.create(:setting, :var => "ration", :value => ration.id)

      visit admin_dishes_path

      page.should have_selector('h2', :text => "Dishes")
      page.should have_selector('table tbody tr td.col-name', :text => own_dish.name)
      page.should have_selector('table tbody tr td.col-name', :text => dish_2.name)
    end

    it "should create dish from ingredients" do
      ration = Factory.create(:ration, :id => 1)

      visit admin_dishes_path

      page.should have_selector('h2', :text => "Dishes")
      within("span.blank_slate") do
        click_link "Create one"
      end

      dish = Factory.create(:dish_schema_a)
      dish_sample = Factory.build(:dish_sample)

      page.should have_selector('h2', :text => "New Dish")
      within("#new_dish") do
        fill_in "Name", :with => dish.name
        click_button "Create Dish"
      end

      page.should have_selector('h2', :text => "New Dish")
      page.should have_selector('ul.errors li', :text => "At least one ingredient should be defined")

      # We can't continue a test because the javascript processing need
      #within("#new_dish") do
        #click_link "Add New Dish composition"
        #select Ingredient.first.name, :from => '#dish_dish_compositions_attributes_0_ingredient_id'
        #click_button "Create Dish"
      #end

      #page.should have_selector('h3', :text => "Dish Details")
      #page.should have_selector('.flash_notice', :text => "Dish was successfully created.")

      #visit admin_dishes_path

      #page.should have_selector('h2', :text => "Dishes")
      #page.should have_selector('table tbody tr td.col-name', :text => dish.name)
      #page.should have_selector('table tbody tr td.col-weight', :text => dish_sample.weight)
      #page.should have_selector('table tbody tr td.col-proteins', :text => dish_sample.proteins)
      #page.should have_selector('table tbody tr td.col-fats', :text => dish_sample.fats)
      #page.should have_selector('table tbody tr td.col-carbs', :text => dish_sample.carbs)
    end

    it "should eat dish" do
      dish = Factory.create(:dish_sample, :user => admin)

      visit admin_dishes_path

      page.should have_selector('h2', :text => "Dishes")
      page.should have_selector('table tbody tr td.col-name', :text => dish.name)
      page.should have_selector('table tbody tr td.col-weight', :text => dish.weight)
      page.should have_selector('table tbody tr td.col-proteins', :text => dish.proteins)
      page.should have_selector('table tbody tr td.col-fats', :text => dish.fats)
      page.should have_selector('table tbody tr td.col-carbs', :text => dish.carbs)

      click_link "Eat"

      page.should have_selector('h2', :text => "New Eaten")
      page.should have_selector('span', :text => "Dish '#{dish.name}'")

      fill_in "Weight", :with => "50"

      #page.execute_script("$('form#your-form').submit()")

      click_button "Create Eaten"

      page.should have_selector('h3', :text => "Eaten Details")
      page.should have_selector('.flash_notice', :text => "Eaten was successfully created.")

      visit admin_eatens_path

      page.should have_selector('h2', :text => "Eatens")
      page.should have_selector('table tbody tr td.col-eatable', :text => dish.name)
      page.should have_selector('table tbody tr td.col-weight', :text => "50")
      page.should have_selector('table tbody tr td.col-proteins', :text => "9.63")
      page.should have_selector('table tbody tr td.col-fats', :text => "15.13")
      page.should have_selector('table tbody tr td.col-carbs', :text => "20.63")

   end

  end
end

