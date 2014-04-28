require 'spec_helper'

describe "Ingredients" do
  let(:admin) { create(:user) }

  before(:each) do
    admin.add_rations
    login_as admin
  end

  describe "Index" do
    context "create new" do
      it "should create for own ration" do
        ingredient = build(:ingredient)

        visit admin_ingredients_path
        click_link('New Ingredient')

        page.should have_selector('h2', :text => "New Ingredient")

        fill_in "ingredient_name", :with => ingredient.name
        fill_in "ingredient_portion", :with => ingredient.portion
        click_button("Create Ingredient")

        current_path.should == admin_ingredients_path
        page.should have_selector('table tbody tr td.col-name', :text => ingredient.name)
      end

      it "should create without referer" do
        ingredient = build(:ingredient)

        visit new_admin_ingredient_path

        fill_in "ingredient_name", :with => ingredient.name
        fill_in "ingredient_portion", :with => ingredient.portion
        click_button("Create Ingredient")

        page.should have_selector('h2', :text => ingredient.name)
      end
    end

    it "should eat ingredient" do
      ingredient = create(:ingredient_sample, :user => admin, :ration => Ration.find(admin.setting(:ration)))

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


