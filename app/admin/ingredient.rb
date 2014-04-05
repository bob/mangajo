ActiveAdmin.register Ingredient do
  config.batch_actions = false
  scope_to :current_user
  #scope_to do
    #Ration.find(current_user.setting(:ration))
  #end
  config.clear_action_items! #unless can? :create, Ingredient

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
    def index
      index! do |format|
        @ingredients = current_user.all_ingredients.page(params[:page])
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
