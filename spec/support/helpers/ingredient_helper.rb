module IngredientHelper
  def create_ingredient_user_ration(factory, user)
    ing = create(factory, :user => user, :ration => Ration.find(user.setting(:ration)))
  end
end
