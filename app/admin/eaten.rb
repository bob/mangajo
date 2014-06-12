ActiveAdmin.register Eaten do
  config.batch_actions = false
  menu :priority => 20, :parent => I18n.t("menu.diary")
  scope_to :current_user
  #config.clear_action_items!

  filter :eatable_type
  filter :proteins
  filter :fats
  filter :carbs
  filter :created_at

  index do
    #selectable_column

    column :eatable
    column :weight
    column("Proteins") { |c| c.proteins.round(2) }
    column("Fats") { |c| c.fats.round(2) }
    column("Carbs") { |c| c.carbs.round(2) }
    column :kcal
    column :created_at

    default_actions
  end

  #form :partial => "form"
  form do |f|
    f.inputs "#{f.object.eatable.class.model_name.human} '#{f.object.eatable.name}'" do
      f.input :weight
      f.input :eatable_id, :as => :hidden
      f.input :eatable_type, :as => :hidden
    end
    f.actions
  end

  controller do
    def new
      new! do |format|
        if params[:dish_id].present?
          @eated = Dish.find(params[:dish_id])
        elsif params[:ingredient_id].present?
          @eated = Ingredient.find(params[:ingredient_id])
        else
          redirect_to admin_eatens_path, :alert => "Please select what to eat"
          return
        end
        @eaten.eatable = @eated
      end
    end
  end
end
