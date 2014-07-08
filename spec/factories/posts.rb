FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Post_#{n}" }

  end
end

