ActiveAdmin.register Ingredient, :as => "SelectIngredient" do

  belongs_to :ration
  config.batch_actions = false
  config.clear_action_items!
  actions :index

  filter :name
  filter :group, :as => :select, :collection => IngredientGroup.all
  filter :proteins
  filter :fats
  filter :carbs

  index :title => "Select ingredient" do
    div link_to("Return to start", session[:ingredient_referer])

    column :name do |c|
      link_to c.name, copy_to_my_admin_ingredient_path(c, :redirect => "edit_selected"), :method => :post
    end
    column :group do |c|
      c.group.name rescue nil
    end
    column :portion do |p|
      portion_caption(p)
    end
    column :proteins
    column :fats
    column :carbs
    column :kcal
  end

  controller do

    def scoped_collection
      if params[:ration_id]
        Ingredient.by_ration params[:ration_id]
      else
        current_user.all_ingredients
      end
    end

  end
end
