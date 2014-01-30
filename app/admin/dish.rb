ActiveAdmin.register Dish do

  index do
    selectable_column

    column :id
    column :name
    column :weight
    column :proteins
    column :fats
    column :carbs
    column :updated_at

    actions :default => true do |d|
      link_to "Eat", new_admin_dish_eaten_path(d)
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
    f.inputs "Details" do
      f.input :name
    end

    f.has_many :dish_compositions, :allow_destroy => true, :heading => "Ingredients" do |i|
      i.inputs "Ingredients" do
        i.input :ingredient_id, :as => :select, :collection => Ingredient.all
        i.input :weight
      end
    end

    f.inputs "Details" do
      f.input :description
    end

    f.actions

  end
end
