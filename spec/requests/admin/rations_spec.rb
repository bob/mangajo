require 'spec_helper'

describe "Rations" do
  describe "Index" do
    let(:user) { Factory.create(:user) }

    before(:each) do
      login_as user
    end

    it "should show own and shared rations" do
      ration = Factory.create(:ration, :user => user)
      user_2 = Factory.create(:user)
      ration_2 = Factory.create(:ration, :user => user_2)
      user.shared_rations << ration_2

      visit admin_rations_path

      page.should have_selector('h2', :text => "Rations")
      page.should have_selector('table tbody tr td.col-name', :text => ration.name)
      page.should have_selector('table tbody tr td.col-name', :text => ration_2.name)
    end

    it "should add new ration" do
      visit admin_rations_path

      page.should have_selector('h2', :text => "Rations")
      within("span.blank_slate") do
        click_link "Create one"
      end

      page.should have_selector('h2', :text => "New Ration")
      within("#new_ration") do
        fill_in "Name", :with => "Test_ration"
        click_button "Create Ration"
      end

      page.should have_selector('h2', :text => "Test_ration")

    end

    it "should not have delete link for not owned ration" do
      ration = Factory.create(:ration, :user => user)
      user_2 = Factory.create(:user)
      ration_2 = Factory.create(:ration, :user => user_2)
      user.shared_rations << ration_2

      visit admin_rations_path

      page.should have_selector('h2', :text => "Rations")
      page.should have_selector('table tbody tr td.col-name', :text => ration.name)
      page.should have_selector('table tbody tr td.col-name', :text => ration_2.name)

      page.should have_selector("table tbody tr td.col a.delete_link[href='#{admin_ration_path(ration.id)}']", :text => "Delete")
      page.should_not have_selector("table tbody tr td.col a.delete_link[href='#{admin_ration_path(ration_2.id)}']", :text => "Delete")


    end

  end
end
