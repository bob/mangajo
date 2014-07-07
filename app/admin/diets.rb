require 'active_admin/post_action'

ActiveAdmin.register Diet do
  include ActiveAdmin::PostAction

  config.batch_actions = false
  menu :priority => 2, :parent => I18n.t("menu.food")
  scope_to :current_user, :association_method => :all_diets

  index do
    column :id
    column :name do |c|
      auto_link c, c.name
    end
    column :description do |c|
      truncate c.description, :length => 60
    end
    column :user if current_user.admin?
    column :published_at
    column :updated_at

    default_actions
  end

  action_item :only => [:show] do
    links = ''
    links += post_action_link(resource)
    links.html_safe
  end

  show do |d|
    attributes_table do
      row :name
      row :user do |r|
        auto_link r.user, r.user.email
      end if current_user.admin?
      row :description
      row :created_at
      row :updated_at
      row :published_at
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
      f.input :description, :as => :ckeditor
    end

    f.has_many :diet_items, :allow_destroy => true, :heading => "Day plans" do |i|
      i.input :plan_id, :as => :select, :collection => current_user.plans, :input_html => {}
      #i.input :order_num
    end

    f.actions
  end

  controller do
    defaults :finder => :find_by_slug
  end
end
