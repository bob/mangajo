ActiveAdmin.register Diet do
  config.batch_actions = false
  #menu :priority => 20
  scope_to :current_user

  show do |d|
    attributes_table do
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Day plans" do
      table_for diet.diet_items do
        column "name" do |appointment|
          auto_link(appointment.plan, appointment.plan.name)
        end
        [:proteins, :fats, :carbs].each do |n|
          column n do |c|
            c.plan.total_nutrition(n)
          end
        end
        column :kcal do |c|
          c.plan.total_kcal
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

    f.has_many :diet_items, :allow_destroy => true, :heading => "Day plans" do |i|
      i.input :plan_id, :as => :select, :collection => current_user.plans, :input_html => {}
      #i.input :order_num
    end

    f.actions
  end
end
