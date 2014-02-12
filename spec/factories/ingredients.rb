FactoryGirl.define do
  factory :ingredient do
    ration { Ration.find_by_id(1) || Factory.create(:ration, :id => 1)}

    sequence(:name) { |n| "Ingredient_#{n}" }
    portion { 100 }
    portion_unit "gramm"
    proteins { rand(100) }
    fats { rand(100) }
    carbs { rand(100) }

    factory :ingredient_schema_a1 do
      proteins "11"
      fats "22"
      carbs "33"
    end

    factory :ingredient_schema_a2 do
      proteins "44"
      fats "55"
      carbs "66"
    end

    factory :ingredient_sample do
      proteins "38.5"
      fats "60.5"
      carbs "82.5"
    end

    factory :nestle_fitness do
      name "Nestle Fitness"
      proteins "8.3"
      fats "2.0"
      carbs "76.4"
    end

    factory :milk do
      name "Milk 2.5"
      proteins "2.8"
      fats "2.5"
      carbs "4.7"
    end

    factory :glair do
      name "Glair"
      proteins "12.7"
      fats "0.3"
      carbs "0.7"
    end

    factory :salt do
      name "Salt"
      proteins "0"
      fats "0"
      carbs "0"
    end

    factory :cheese do
      name "Cheese"
      proteins "23.2"
      fats "29.5"
      carbs "0"
    end

    factory :sugar do
      name "Sugar"
      proteins "0"
      fats "0"
      carbs "99.9"
    end

    factory :ingredient_empty do
      name "Empty"
      proteins "0"
      fats "0"
      carbs "0"
    end


  end
end

