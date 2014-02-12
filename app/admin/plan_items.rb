ActiveAdmin.register PlanItem do
  belongs_to :plan

  form do |f|
    f.inputs do
      f.input :dish, :as => :select, :collection => Dish.by_ration(current_user.setting(:ration))
      f.input :meal_id, :as => :hidden

    end

    f.actions
  end

  controller do
    def new
      new! do |format|
        if params[:meal_id].present?
          @plan_item.meal = Meal.find(params[:meal_id])
        end
      end
    end

    def create
      create!{ admin_plan_path(@plan) }
    end

    def update
      update!{ admin_plan_path(@plan) }
    end

    def destroy
      destroy! do |format|
        redirect_to admin_plan_path(@plan) and return
      end
    end


  end

end

