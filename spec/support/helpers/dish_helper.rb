module DishHelper
  def create_dish_user_ration(factory, user)
    dish = create(factory, :user => user)
    create(:dish_composition, :dish => dish,
           :ingredient => create(:ingredient_empty, :ration_id => user.setting(:ration)))
    dish
  end
end
