FactoryGirl.define do
  factory :eaten do
    eatable { create(:dish_sample) }
    weight "200"
    proteins "38.5"
    fats "60.5"
    carbs "82.5"
  end
end
