ActiveAdmin.register PlanItem do
  belongs_to :plan

  form do |f|
    f.inputs do
      f.input :dish_id, :as => :select, :collection => current_user.all_dishes
      f.input :meal_id, :as => :hidden
    end
    f.form_buffers.last << Arbre::Context.new({}, f.template) do
      span "OR"
    end
    f.inputs do
      f.input :ingredient_id, :as => :select, :collection => current_user.all_ingredients
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
      @dish = current_user.all_dishes.find(params[:plan_item].delete(:dish_id)) rescue nil
      @ingredient = current_user.all_ingredients.find(params[:plan_item].delete(:ingredient_id)) rescue nil

      obj = @dish.present? ? @dish : @ingredient

      params[:plan_item][:eatable_id] = obj.id
      params[:plan_item][:eatable_type] = obj.class.to_s
      params[:plan_item][:weight] = obj.weight

      create!{
        admin_plan_path(@plan)
      }
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

