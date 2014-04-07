require 'spec_helper'

describe PlanItem do
  describe "Associations" do
    it { should belong_to(:plan) }
    it { should belong_to(:eatable) }

  end
end
