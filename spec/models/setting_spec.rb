require 'spec_helper'

describe Setting do
  context "Associations" do
    it { should belong_to(:thing) }
  end

  context "Recalculating" do
    it "should calculate nutritions based on weight" do
      user = create(:user)
      weight_setting = create(:setting, :var => "weight", :value => 80)
      user.settings << weight_setting

      weight_setting.recalculate!

      user.setting_by_var("proteins").value.should == "160.0"
      user.setting_by_var("fats").value.should == "40.0"
      user.setting_by_var("carbs").value.should == "320.0"
    end
  end

end

