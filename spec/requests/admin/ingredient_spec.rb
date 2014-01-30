require 'spec_helper'

describe "Ingredients" do
  describe "Index" do
    let(:admin) { Factory.create(:user) }

    before(:each) do
      login_as admin
    end

    it "should eat ingredient" do
      ingredient = Factory.create(:ingredient_sample)

      visit admin_ingredients_path

      page.should have_selector('h2', :text => "Ingredients")
      page.should have_selector('table tbody tr td.col-name', :text => ingredient.name)
      page.should have_selector('table tbody tr td.col-portion', :text => "#{ingredient.portion} g")
      page.should have_selector('table tbody tr td.col-proteins', :text => ingredient.proteins)
      page.should have_selector('table tbody tr td.col-fats', :text => ingredient.fats)
      page.should have_selector('table tbody tr td.col-carbs', :text => ingredient.carbs)

      click_link "Eat"

      page.should have_selector('h2', :text => "New Eaten")
      page.should have_selector('span', :text => "Ingredient '#{ingredient.name}'")

      fill_in "Weight", :with => "50"

      click_button "Create Eaten"

      page.should have_selector('h3', :text => "Eaten Details")
      page.should have_selector('.flash_notice', :text => "Eaten was successfully created.")

      visit admin_eatens_path

      page.should have_selector('h2', :text => "Eatens")
      page.should have_selector('table tbody tr td.col-eatable', :text => ingredient.name)
      page.should have_selector('table tbody tr td.col-weight', :text => "50")
      page.should have_selector('table tbody tr td.col-proteins', :text => "19.25")
      page.should have_selector('table tbody tr td.col-fats', :text => "30.25")
      page.should have_selector('table tbody tr td.col-carbs', :text => "41.25")

   end

  end
end


