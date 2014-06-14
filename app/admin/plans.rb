ActiveAdmin.register Plan do
  config.batch_actions = false
  menu :priority => 3, :parent => I18n.t("menu.food")
  scope_to :current_user, :association_method => :all_plans

  filter :name
  filter :created_at

  action_item :only => :show do
    html = ''
    html += link_to "Copy", copy_admin_plan_path(plan), :method => :post
    html += link_to "Auto weights", auto_weights_admin_plan_path(plan), :method => :post, :data => {:confirm => "Are you sure?"}
    html.html_safe
  end

  member_action :copy, :method => :post do
    @plan = current_user.plans.find(params[:id])
    @new_plan, message = @plan.do_copy

    if @new_plan
      redirect_to admin_plan_path(@new_plan), :notice => "Plan copied"
    else
      redirect_to amdin_plan_path(@plan), :alert => "Plan NOT copied: #{message}"
    end
  end

  member_action :auto_weights, :method => :post do
    @plan = Plan.find(params[:id])
    @plan.auto_weights!

    redirect_to admin_plan_path(@plan), :notice => "Weigths auto calculated!"
  end

  show do |s|
    render :partial => "show_top", :locals => {:s => s}

    Meal.find_for(s.meals_num).each do |m|
      render :partial => "show_meal", :locals => {:m => m, :current_user => current_user, :s => s}
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :meals_num, :as => :select, :collection => (1...8)
      f.input :description
    end

    f.actions
  end

end
