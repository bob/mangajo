ActiveAdmin.register Plan do
  menu :priority => 1
  scope_to :current_user

  action_item :only => :show do
    link_to "Auto weights", auto_weights_admin_plan_path(plan), :method => :post#, :data => {:confirm => "Are you sure?"}
  end

  member_action :auto_weights, :method => :post do
    @plan = Plan.find(params[:id])
    @plan.auto_weights!

    redirect_to admin_plan_path(@plan), :notice => "Weigths auto calculated!"
  end

  show do |s|
    render :partial => "show_top", :locals => {:s => s}

    Meal.find_for(current_user.setting(:meals)).each do |m|
      render :partial => "show_meal", :locals => {:m => m, :current_user => current_user, :s => s}
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end

    f.actions
  end

end
