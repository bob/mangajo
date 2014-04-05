module ActiveAdmin::ViewsHelper #camelized file name
  def params_day_date
    (params[:d] || Date.today).to_date
  end

  def ingredients_options_with_portion_unit(selected=nil)
    ingredients = Ingredient.by_ration(current_user.setting(:ration)).map do |i|
      [i.name, i.id, {:pu => i.portion_unit}]
    end

    options_for_select(ingredients, selected)
  end
end



