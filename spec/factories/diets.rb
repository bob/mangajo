FactoryGirl.define do
  factory :diet do
    sequence(:name) { |n| "Diet_#{n}" }

  end
end
