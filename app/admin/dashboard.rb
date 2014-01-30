ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :style => "text-align: center; margin: 1em;" do
      span :style => "margin-right: 3em; font-size: 1.5em" do
        link_to "<<", admin_dashboard_path(:d => params_day_date - 1.day)
      end
      span :style => "font-size: 3em;" do
        params_day_date
      end
      span :style => "margin-left: 3em; font-size: 1.5em" do
        link_to ">>", admin_dashboard_path(:d => params_day_date + 1.day)
      end
    end

    #div :class => "blank_slate_container", :id => "dashboard_default_message" do
      #span :class => "blank_slate" do
        #span I18n.t("active_admin.dashboard_welcome.welcome")
        #small I18n.t("active_admin.dashboard_welcome.call_to_action")
      #end
    #end

    columns do
      column do
        panel "Eated" do
          table_for current_user.eatens.find_day(params[:d]) do
            column("Name") {|e| link_to e.eatable.name, admin_eaten_path(e)}
            column("Proteins") {|e| e.proteins.round(2)}
            column("Fats") {|e| e.fats.round(2)}
            column("Carbs") {|e| e.carbs.round(2)}
            column("At") {|e| e.updated_at.to_s(:short)}
          end
        end
      end

      column do
        panel "Today Info" do
          para "Proteins: #{current_user.eatens.find_day(params[:d]).sum(:proteins).round(2)} (#{current_user.setting(:proteins)})"
          para "Fats: #{current_user.eatens.find_day(params[:d]).sum(:fats).round(2)} (#{current_user.setting(:fats)})"
          para "Carbs: #{current_user.eatens.find_day(params[:d]).sum(:carbs).round(2)} (#{current_user.setting(:carbs)})"
        end
      end
    end
  end # content
end
