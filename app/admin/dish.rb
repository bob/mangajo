ActiveAdmin.register Dish do
  config.batch_actions = false
  config.clear_action_items!

  scope_to :current_user

  filter :name
  filter :proteins
  filter :fats
  filter :carbs

  action_item :only => [:index] do
    link_to "New Dish", new_admin_dish_path
  end

  action_item :only => [:show] do
    dish_links(resource)
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
      f.input :description
    end

    f.has_many :dish_compositions, :allow_destroy => true, :heading => "Ingredients" do |i|
      i.form_buffers.last << Arbre::Context.new({}, f.template) do
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
  end

end
