FactoryGirl.define do
  factory :plan do
    sequence(:name) { |n| "Plan_#{n}" }

    factory :plan_second do
      name "Second"

    end
  end
end
