require 'spec_helper'

describe "Ingredients" do
  include IngredientHelper

  let(:admin) { create(:user) }

  before(:each) do
    admin.add_rations
    login_as admin
  end

  describe "Index" do
    context "create new" do
      before(:each) do
        @ingredient = build(:ingredient)
      end

      it "should create for own ration" do
        visit admin_ingredients_path
        click_link('New Ingredient')

        page.should have_selector('h2', :text => "New Ingredient")

        fill_in "ingredient_name", :with => @ingredient.name
        fill_in "ingredient_portion", :with => @ingredient.portion
        click_button("Create Ingredient")

        current_path.should == admin_ingredients_path
        page.should have_selector('table tbody tr td.col-name', :text => @ingredient.name)
      end

      it "should create from ration" do
        default_ration = Ration.get_default
        default_ingredient = create(:ingredient, :user => default_ration.user, :ration => default_ration)

        visit admin_ingredients_path
        click_link('New Ingredient')

        within("span.action_item") do
          click_link "Rations"
        end

        click_link default_ration.name
        click_link default_ingredient.name

        click_button "Update Ingredient"

        current_path.should == admin_ingredients_path
        page.should have_selector('table tbody tr td.col-name', :text => default_ingredient.name)
      end

      it "should create without referer" do
        visit new_admin_ingredient_path

        fill_in "ingredient_name", :with => @ingredient.name
        fill_in "ingredient_portion", :with => @ingredient.portion
        click_button("Create Ingredient")

        page.should have_selector('h2', :text => @ingredient.name)
      end
    end

    context "edit" do
      before(:each) do
        @ingredient = create_ingredient_user_ration(:ingredient, admin)
      end

      it "should edit and return to index" do
        visit admin_ingredients_path

        within("tr#ingredient_#{@ingredient.id}") do
          click_link "Edit"
        end

        fill_in "ingredient_name", :with => "New one"
        click_button("Update Ingredient")

        page.should have_selector('h2', :text => "Ingredients")
        page.should have_selector('table tbody tr td.col-name', :text => "New one")
      end

      it "should edit and return to show" do
        visit admin_ingredient_path(@ingredient)

        click_link "Edit"
        fill_in "ingredient_name", :with => "New second"
        click_button "Update Ingredient"

        page.should have_selector('h2', :text => "New second")
      end

    end

    it "should eat ingredient" do
      ingredient = create_ingredient_user_ration(:ingredient_sample, admin)

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


