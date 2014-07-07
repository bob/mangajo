require 'spec_helper'

describe "Diets" do

  describe "Postable" do
    let(:user) { create(:user) }

    before(:each) do
      ration = create(:ration, :user => user)
      ration_setting = create(:setting, :var => "ration", :value => ration.id)
      user.settings << ration_setting
      login_as user
    end

    it "should work about diet" do
      diet = create(:diet, :user => user)

      visit admin_diets_path

      click_link diet.name
      click_link "Create post"

      page.should have_selector('h2', :text => "Edit Post")

      fill_in "Title", :with => "DDD"
      click_button "Update Post"

      within "span.action_item" do
        click_link "Diet"
      end

      click_link "Edit post"
      click_link "Preview"

      page.should have_selector('h1', :text => "DDD")
    end

  end

end
