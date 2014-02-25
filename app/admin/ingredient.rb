ActiveAdmin.register Ingredient do
  config.batch_actions = false
  scope_to do
    Ration.find(current_user.setting(:ration))
  end
  config.clear_action_items! #unless can? :create, Ingredient

  action_item :only => [:index] do
    ingredient = Ingredient.new
    ingredient.ration = Ration.find(current_user.setting(:ration))

    if authorized? :new, ingredient
      link_to "New Ingredient", new_admin_ingredient_path
    else
      link_to "New Ingredient", nil, :data => {:confirm => "You can't create Ingredient for current Ration. Please choose your own Ration first."}
    end
  end

  filter :name
  filter :proteins
  filter :fats
  filter :carbs

  index do
    #selectable_column
    #column :id
    column :name do |c|
      auto_link c, c.name
    end
    column :portion do |p|
      "#{p.portion} #{Ingredient::PORTION_UNITS[p.portion_unit.to_sym]}"
    end
    column :proteins
    column :fats
    column :carbs
    #column :updated_at

    column "" do |resource|
      links = ''.html_safe
      if authorized? :edit, resource
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
        links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link"
      end
      links += link_to "Eat", new_admin_ingredient_eaten_path(resource)
      links
    end
  end

  form  do |f|
    f.inputs  do
      f.input :name
      f.input :portion
      f.input :portion_unit, :collection => Ingredient::PORTION_UNITS.invert, :default => :gramm
      f.input :proteins
      f.input :fats
      f.input :carbs
    end
    f.actions
  end

  controller do
  end
end
