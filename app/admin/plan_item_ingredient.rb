ActiveAdmin.register PlanItemIngredient do
  belongs_to :plan_item

  form do |f|
    f.inputs do
      if f.object.ingredient.portion_unit == "gramm"
        f.input :weight
      elsif f.object.ingredient.portion_unit == "item"
        f.input :portion
      end
    end
    f.actions
  end

  controller do
    def update
      update! {
        @plan_item.recalculate_weight
        redirect_to admin_plan_path(@plan_item.plan) and return
      }
    end

    def destroy
      destroy! do |format|
        @plan_item.recalculate_weight
        redirect_to admin_plan_path(@plan_item.plan) and return
      end
    end

  end

end


