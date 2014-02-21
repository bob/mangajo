require 'spec_helper'

describe User do
  context "Associations" do
    it { should have_many(:settings) }
    it { should have_and_belong_to_many(:shared_rations) }
    it "should return current dishes" do
      user = Factory.create(:user)
      dish = double(:dish)
      Dish.should_receive(:by_ration).with(1).and_return([dish])
      user.current_dishes.should include(dish)
    end
  end

  context "Settings" do
    let(:user) { Factory.create(:user) }

    it "should return saved value" do
      user.settings << Factory.create(:setting, :var => "proteins", :value => 111)
      user.setting(:proteins).should == "111"
    end

    it "should return default value" do
      conf = Setting.default_conf
      first_var = conf.keys.first

      user.settings.destroy_all

      user.setting(first_var).should == conf[first_var]["value"]
    end

    it "should get full settings (with defaults)" do
      conf = Setting.default_conf
      first_var = conf.keys.first
      last_var = conf.keys.last

      user.settings << Factory.create(:setting, :var => first_var)

      defaults = user.full_settings.map(&:var)

      defaults.should include(last_var)
      defaults.should include(first_var)
    end

    it "should set default ration after create" do
      user.setting(:ration).should == 1
    end

  end

end
