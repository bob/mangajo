FactoryGirl.define do
  factory :setting do
    sequence(:var) { |n| "var#{n}" }
    sequence(:title) { |n| "Title_#{n}" }
    value { rand(100) }

  end
end

