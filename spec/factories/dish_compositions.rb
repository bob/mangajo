FactoryGirl.define do
  factory :dish_composition do
    #association :dish
    #association :ingredient
    weight { rand(100) }

    factory :dish_composition_schema_a1 do
      weight "150"
    end

    factory :dish_composition_schema_a2 do
      weight "50"
    end

  end
end



