module ActiveAdmin::ViewsHelper #camelized file name
  def params_day_date
    (params[:d] || Date.today).to_date
  end

  def ingredients_options_with_portion_unit(selected=nil)
    #ingredients = Ingredient.by_ration(current_user.setting(:ration)).map do |i|
    ingredients = current_user.all_ingredients.map do |i|
      [i.name, i.id, {:pu => i.portion_unit}]
    end

    options_for_select(ingredients, selected)
  end

  def dish_links(resource)
    links = ''.html_safe
    if current_user.id == resource.user.id
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link"
    end
    links += link_to "Eat", new_admin_dish_eaten_path(resource)
    links
  end

  def ingredient_links(resource)
    links = ''.html_safe

    if current_user.id == resource.user.id
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link"
    else
      links += link_to "Copy to my", copy_to_my_admin_ingredient_path(resource), :method => :post, :class => "member_link edit_link"
    end

    links += link_to "Eat", new_admin_ingredient_eaten_path(resource)

    links
  end

  def portion_caption(p)
    "#{p.portion} #{(Ingredient::PORTION_UNITS[:gramm] + "/") if p.portion_unit != "gramm" }#{Ingredient::PORTION_UNITS[p.portion_unit.to_sym]}"
  end

end



