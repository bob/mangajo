require 'spec_helper'

describe Ration do
  let(:user) { create(:user) }

  describe "Associations" do
    it { should have_many(:ingredients) }
    it { should have_and_belong_to_many(:customers) }

  end

  it "should create new" do
    ration = Ration.new(:name => "Common", :description => "Test")
    ration.user = user
    ration.save

    ration.reload
    ration.name.should == "Common"
    ration.user.should == user
  end

  it "should have customer" do
    ration = create(:ration)
    customer = create(:user)
    ration.customers << customer

    ration.customers.first.should == customer
  end

  it "should set setting to default" do
    user = create(:user)
    ration = create(:ration, :user => user)
    ration_setting = create(:setting, :var => "ration", :value => ration.id)
    user.settings << ration_setting

    expect { Ration.set_setting_to_default(user) }.to change{user.setting(:ration)}.from(ration.id.to_s).to(1)
  end

  it "should set setting when delete" do
    user = create(:user)
    ration_2 = create(:ration, :user => user)
    ration_setting = create(:setting, :var => "ration", :value => ration_2.id)
    user.settings << ration_setting

    expect{ ration_2.destroy }.to change{user.setting(:ration)}.to(1)
  end


end
