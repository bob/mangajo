ActiveAdmin.register Ingredient do
  config.batch_actions = false
  config.clear_action_items! #unless can? :create, Ingredient

  breadcrumb do
    crumbs = [
      link_to("admin", admin_root_path)
    ]

    if params[:ration_id]
      ration = Ration.find(params[:ration_id])

      crumbs += [link_to("rations", admin_rations_path)]
      crumbs += [link_to(ration.name, admin_ration_path(ration))]
    end
    crumbs
  end

  member_action :copy_to_my, :method => :post do
    ingredient = Ingredient.find params[:id]
    new_ingredient = ingredient.dup
    new_ingredient.user = current_user
    new_ingredient.ration_id = current_user.setting(:ration)

    if new_ingredient.save
      flash[:notice] = "Ingredient copied"
    else
      flash[:error] = "Ingredient NOT copied"
    end

    redirect_to request.referer
  end

  action_item :only => [:index] do
    link_to "New Ingredient", new_admin_ingredient_path
  end

  action_item :only => [:show] do
    ingredient_links(resource)
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
      "#{p.portion} #{(Ingredient::PORTION_UNITS[:gramm] + "/") if p.portion_unit != "gramm" }#{Ingredient::PORTION_UNITS[p.portion_unit.to_sym]}"
    end
    column :proteins
    column :fats
    column :carbs
    column :kcal
    #column :updated_at

    column "" do |resource|
      ingredient_links(resource)
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
    def scoped_collection
      if params[:ration_id]
        Ingredient.by_ration params[:ration_id]
      else
        current_user.all_ingredients
      end
    end

    def show
      @ingredient = Ingredient.find(params[:id])
    end

    def create
      create! do |format|
        @ingredient.update_column(:ration_id, current_user.setting(:ration))
      end
    end

  end
end
