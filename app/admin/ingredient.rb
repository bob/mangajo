ActiveAdmin.register Ingredient do
  menu :priority => 5, :parent => I18n.t("menu.food")
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

  collection_action :rations_list, :method => :get, :title => "Rations" do
    render :template => "admin/ingredients/rations", :locals => {:rations => current_user.all_rations}
  end

  member_action :copy_to_my, :method => :post do
    ingredient = Ingredient.find params[:id]
    new_ingredient = ingredient.dup
    new_ingredient.user = current_user
    new_ingredient.ration_id = current_user.setting(:ration)

    if new_ingredient.save
      flash[:notice] = "Ingredient copied"

      case params[:redirect]
      when "edit_selected"
        redirect_to edit_admin_ingredient_path(new_ingredient)
      else
        redirect_to request.referer
      end
    else
      flash[:error] = "Ingredient NOT copied"
      redirect_to request.referer
    end

  end

  action_item :only => [:index] do
    link_to "New Ingredient", new_admin_ingredient_path
  end

  action_item :only => [:show] do
    ingredient_links(resource)
  end

  action_item :only => [:new] do
    link_to("Rations", rations_list_admin_ingredients_path, :title => "Copy from rations")
  end

  filter :name
  filter :group, :as => :select, :collection => IngredientGroup.all
  filter :proteins
  filter :fats
  filter :carbs

  index do
    #selectable_column
    #column :id
    column :name do |c|
      auto_link c, c.name
    end
    column :group
    column :portion do |p|
      portion_caption(p)
    end
    column :proteins
    column :fats
    column :carbs
    column :kcal

    column "" do |resource|
      ingredient_links(resource)
    end
  end

  form  do |f|
    f.form_buffers.last << Arbre::Context.new({}, f.template) do
      div link_to("Return to start", session[:ingredient_referer])
    end

    f.inputs  do
      f.input :name
      f.input :group
      f.input :portion
      f.input :portion_unit, :collection => Ingredient::PORTION_UNITS.invert, :default => :gramm
      f.input :proteins
      f.input :fats
      f.input :carbs
    end
    f.actions
  end

  controller do
    #layout 'active_admin'

    def scoped_collection
      if params[:ration_id]
        Ingredient.by_ration params[:ration_id]
      else
        current_user.all_ingredients
      end
    end

    def new
      new! {
        session[:ingredient_referer] = request.referer
      }
    end

    def edit
      super {
        session[:ingredient_referer] ||= request.referer
      }
    end

    def show
      @ingredient = Ingredient.find(params[:id])
    end

    def create
      super do |success, failure|
        success.html {
          @ingredient.update_column(:user_id, current_user.id)
          @ingredient.update_column(:ration_id, current_user.setting(:ration))

          redirect_to redirect_referer(@ingredient)
        }
      end
    end

    def update
      super do |success, failure|
        success.html {
          redirect_to redirect_referer(@ingredient)
        }
      end
    end

    private
    def redirect_referer(ingredient)
      if session[:ingredient_referer].blank?
        redirect_path = admin_ingredient_path(ingredient)
      else
        redirect_path = session[:ingredient_referer]
        session[:ingredient_referer] = nil
      end
      redirect_path
    end

  end
end
