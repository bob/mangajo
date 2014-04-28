require 'spec_helper'

describe User do
  context "Associations" do
    it { should have_many(:settings) }
    it { should have_and_belong_to_many(:shared_rations) }
    it "should return dishes for current ration" do
      user = create(:user)
      dish = double(:dish)
      Dish.should_receive(:by_ration_and_own).and_return([dish])
      user.all_dishes.should include(dish)
    end
    it { should have_many(:dishes) }
  end

  context "Settings" do
    let(:user) { create(:user) }

    it "should return saved value" do
      user.settings << create(:setting, :var => "proteins", :value => 111)
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
      last_var = conf.keys.last

      first_var = conf.keys.first # should be 'ration'
      user.settings << create(:setting, :var => first_var, :value => create(:ration, :user => create(:user)))

      defaults = user.full_settings.map(&:var)

      defaults.should include(last_var)
      defaults.should include(first_var)
    end

    it "should not create 'ration' for not own ration" do
      other_ration = create(:ration, :user => create(:user))

      ration_setting = build(:setting, :var => "ration", :value => other_ration.id, :thing => user)
      ration_setting.save

      user.reload

      ration_setting.errors.keys.should include(:base)
      user.setting(:ration).should_not == other_ration.id
    end

    it "should set default ration after create" do
      real_ration = create(:ration, :user => create(:user))
      ration = double(Ration, :id => real_ration.id).as_null_object
      Ration.should_receive(:new).and_return(ration)

      user.setting(:ration).should == ration.id
    end

  end

end
