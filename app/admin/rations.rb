ActiveAdmin.register Ration do
  config.batch_actions = false
  #menu :priority => 1
  scope_to :current_user

  filter :name
  filter :created_at

  index do
    #selectable_column
    #column :id
    column :name do |c|
      auto_link c, c.name
    end
    column :description
    column :ingredients do |c|
      c.ingredients.count
    end
    column :updated_at

    column "" do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link"
      links += current_user.setting(:ration).to_i == resource.id ? "Current " : link_to("Choose", admin_settings_update_path(:var => "ration", :value => resource.id, :ref => admin_rations_path), :method => :post, :class => "member_link")

      links
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

