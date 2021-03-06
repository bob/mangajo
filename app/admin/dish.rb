require 'active_admin/post_action'

ActiveAdmin.register Dish do
  include ActiveAdmin::PostAction

  menu :priority => 4, :parent => I18n.t("menu.food")
  config.batch_actions = false
  config.clear_action_items!

  scope_to :current_user

  filter :name
  filter :proteins
  filter :fats
  filter :carbs

  collection_action :new_ingredient, :method => :post do
    session[:new_dish] = params[:dish]
    redirect_to new_admin_ingredient_path
  end

  action_item :only => [:index] do
    link_to "New Dish", new_admin_dish_path
  end

  action_item :only => [:show] do
    html = ''
    html += post_action_link(resource)
    html += dish_links(resource)
    html.html_safe
  end

  index do
    #selectable_column

    column :name do |c|
      auto_link c, c.name
    end
    column :weight
    column :proteins
    column :fats
    column :carbs
    column :kcal

    column "" do |resource|
      dish_links(resource)
    end

  end

  show do |d|
    attributes_table do
      row :name
      row :description
      row :weight
      row :proteins
      row :fats
      row :carbs
      row :prep_time
      row :cook_time
      row :portions
    end

    panel "Ingredients" do
      table_for dish.dish_compositions do
        column "name" do |appointment|
          auto_link(appointment.ingredient, appointment.ingredient.name)
        end
        column "quantity" do |c|
          if c.portion_unit == "item"
            "#{c.portions} #{c.portion_unit.pluralize} (#{c.weight} g)"
          else
            "#{c.weight} g"
          end
        end
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Details" do
      f.input :name
      f.input :description, :as => :ckeditor
      f.input :prep_time, :as => :select, :collection => durations_options(f.object.prep_time)
      f.input :cook_time, :as => :select, :collection => durations_options(f.object.cook_time)
      f.input :portions, :as => :select, :collection => (1..20)
    end

    f.has_many :dish_compositions, :allow_destroy => true, :heading => "Ingredients" do |i|
      i.form_buffers.last << Arbre::Context.new({}, f.template) do
        li link_to("Create new ingredient", "#", :id => "new_ingredient_#{i.index}", :class => "new_ingredient")
      end

      i.input :ingredient_id, :as => :select, :collection => ingredients_options_with_portion_unit(i.object.ingredient_id), :input_html => {:class => "dish_ingredient_select"}

      i.input :portions, :wrapper_html => ({:style => "display: none;"} if i.object.portion_unit == "gramm" or i.object.new_record?)
      i.input :weight, :wrapper_html => ({:style => "display: none;"} if i.object.portion_unit == "item" or i.object.new_record?)
    end

    f.actions

    f.form_buffers.last << Arbre::Context.new({}, f.template) do
      script :type => "text/javascript" do
        "switch_dish_ingredients();"
      end
    end
  end

  controller do
    def index
      index! do |format|
        @dishes = current_user.all_dishes.page(params[:page])
      end
    end

    def show
      @dish = Dish.find(params[:id])
    end

    def new
      if session[:new_dish]
        @dish = Dish.new session[:new_dish]
        session[:new_dish] = nil
      end
      super {
        @dish.dish_compositions << DishComposition.new if @dish.dish_compositions.empty?
      }
    end

    def edit
      super {
        if session[:new_dish]
          @dish.attributes = session[:new_dish]
          session[:new_dish] = nil
        end
      }
    end
  end

end
