require 'spec_helper'

describe Ration do
  let(:user) { Factory.create(:user) }

  describe "Associations" do
    it { should have_many(:ingredients) }

  end

  it "should create new" do
    ration = Ration.new(:name => "Common", :description => "Test")
    ration.user = user
    ration.save

    ration.reload
    ration.name.should == "Common"
    ration.user.should == user
  end
end
