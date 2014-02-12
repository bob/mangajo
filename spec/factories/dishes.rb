FactoryGirl.define do
  factory :dish do
    sequence(:name) { |n| "Dish_#{n}" }
    dish_compositions { [
      Factory.create(:dish_composition, :ingredient => Factory.create(:ingredient_empty))
    ] }

    factory :dish_schema_a do
      dish_compositions { [
        Factory.create(:dish_composition_schema_a1, :ingredient => Factory.create(:ingredient_schema_a1)),
        Factory.create(:dish_composition_schema_a2, :ingredient => Factory.create(:ingredient_schema_a2))
      ] }
    end

    factory :dish_sample do
      dish_compositions { [
        Factory.create(:dish_composition, :ingredient => Factory.create(:ingredient, :proteins => 19.25, :fats => 30.25, :carbs => 41.25), :weight => 200)
      ] }
      name "Dish_sample"
      weight "200"
      proteins "38.5"
      fats "60.5"
      carbs "82.5"
    end

    factory :flakes do
      name "Flakes"
      weight "95"
      proteins "7.06"
      fats "1.975"
      carbs "61.825"

      #dish_compositions { [
        #Factory.create(:dish_composition, :weight => 80, :ingredient => Factory.create(:nestle_fitness)),
        #Factory.create(:dish_composition, :weight => 15, :ingredient => Factory.create(:milk))
      #] }

    end

    factory :omelet do
      name "Omelet"
      weight "91"
      proteins "11.557"
      fats "0.273"
      carbs "0.637"
    end
  end
end


