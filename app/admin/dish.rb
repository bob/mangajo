ActiveAdmin.register Dish do
  config.batch_actions = false

  scope_to :current_user

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
    column :weight
    column :proteins
    column :fats
    column :carbs
    #column :updated_at

    #actions :default => true do |d|
      #link_to "Eat", new_admin_dish_eaten_path(d)
    #end
    column "" do |resource|
      links = ''.html_safe
      if current_user.id == resource.user.id
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
        links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link"
      end
      links += link_to "Eat", new_admin_dish_eaten_path(resource)
      links
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
        column :weight
      end
    end

    active_admin_comments
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs "Details" do
      f.input :name
    end

    f.has_many :dish_compositions, :allow_destroy => true, :heading => "Ingredients" do |i|
      i.inputs "Ingredients" do
        i.input :ingredient_id, :as => :select, :collection => Ingredient.by_ration(current_user.setting(:ration))
        i.input :weight
      end
    end

    f.inputs "Details" do
      f.input :description
    end

    f.actions

  end

  controller do
    def index
      index! do |format|
        @dishes = current_user.all_dishes.page(params[:page])
      end
    end
  end

end
