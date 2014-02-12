FactoryGirl.define do
  factory :ration do
    sequence(:name) { |n| "Ration_#{n}" }

    factory :ration_second do
      name "Ration Second"

    end
  end
end

