require 'spec_helper'

describe Eaten do
  describe "Associations" do
    it { should belong_to(:eatable) }
    it { should belong_to(:user) }
  end

  describe "Day" do
    let(:past) { create(:eaten, :created_at => "2013-11-04 14:00") }
    let(:present) { create(:eaten, :created_at => "2013-11-05 14:00") }

    before(:each) do
      Date.stub(:today).and_return("2013-11-05 15:00:00")
    end

    it "should find for today" do
      eatens = Eaten.find_day
      eatens.should include(present)
      eatens.should_not include(past)
    end

    it "should find for yesterday" do
      eatens = Eaten.find_day("2013-11-04")
      eatens.should include(past)
      eatens.should_not include(present)
    end
  end

end
