require 'spec_helper'

describe DishComposition do
  describe "Associations" do
    it { should belong_to(:dish) }
    it { should belong_to(:ingredient) }
  end
end
