ActiveAdmin.register Diet do
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

  member_action :publish, :method => :post, :if => Proc.new{ current_user.admin? } do
    resource.publish
    redirect_to admin_diet_path(resource), :notice => "Diet published"
  end

  member_action :unpublish, :method => :post, :if => Proc.new{ current_user.admin? } do
    resource.unpublish
    redirect_to admin_diet_path(resource), :notice => "Diet unpublished"
  end

  action_item :only => [:show], :if => Proc.new{ current_user.admin? } do
    if resource.published?
      link_to "Unpublish", unpublish_admin_diet_path(resource), :method => :post
    else
      link_to "Publish", publish_admin_diet_path(resource), :method => :post
    end
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
      f.input :description
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
