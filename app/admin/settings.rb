ActiveAdmin.register_page "Settings" do

  page_action :update, :method => :post do
    setting = current_user.settings.find_by_var(params[:var])

    if params[:reset]
      setting.destroy if setting
      redirect_to admin_settings_path, :notice => "Setting was reset"
      return
    end

    unless setting
      setting = current_user.settings.build(:var => params[:var])
    end

    setting.value = params[:value]
    if setting.save
      setting.recalculate!

      redirect_to (params[:ref].blank? ? admin_settings_path : params[:ref]), :notice => "Setting '#{setting.title}' updated"
    else
      redirect_to admin_settings_path, :alert => "Setting '#{setting.title}' not updated. #{setting.errors.full_messages.join(', ')}"
    end
  end

  content do
    current_user.full_settings.each do |s|
      next if s.hidden
      para do
        form :action => admin_settings_update_path, :method => :post do |f|
          f.input :type => :hidden, :name => 'authenticity_token', :value => form_authenticity_token.to_s
          f.input :type => :hidden, :name => 'var', :value => s.var

          para b f.label s.title
          para i s.description
          f.input :type => :text, :name => 'value', :value => s.value, :size => 50
          f.input :type => :submit, :value => "Update"
          f.input :type => :submit, :name => "reset", :value => "Reset"
        end
      end
    end
  end


  #page_action :update, :method => :post do

    #Settings.all.each do |s|
      #if !params[s[0]].nil? && params[s[0]] != s[1]
        #Settings[s[0]] = params[s[0]]
      #end
    #end

    #redirect_to admin_settings_path, :notice => "Settings updated"
  #end

  #content do
    #form :action =>  admin_settings_update_path, :method => :post, :class => 'settings' do |f|
      #f.input :name => 'authenticity_token', :type => :hidden, :value => form_authenticity_token.to_s

      #para 'Caution! Changes may cause undesired operation!', :class => 'warning'

      #Settings.all.each do |setting |
          #para do
            #label setting[0]
            #f.input :value =>setting[1] , :name => setting[0], :type => :text
          #end
        #end

        #f.input :type => :submit, :value => "Save"
      #end
  #end








  #scope_to :current_user

  #config.batch_actions = false
  #actions :all, :except => [:new, :show]
  #config.filters = false

  #index do
    #column :var
    #column :title
    #column :value
    #column :updated_at
    #default_actions
  #end

  #form do |f|
    #f.inputs do
      #f.input :value, :as => :string, :label => "#{f.object.title}"
    #end
    #f.actions
  #end

  #controller do
    #def find_collection
      #res = current_user.settings
      #res = apply_pagination(res)

      #current_user.missed_settings.each do |d|
        #res << d
      #end

      #res
    #end


    #def resource
      #setting = current_user.settings.find_by_id(params[:id])
      #unless setting
        #default_setting = Setting.unscoped.where("thing_type is NULL and thing_id is NULL").find(params[:id])
        #current_user.settings[default_setting.var.to_sym] = default_setting.to_hash

        #setting = current_user.settings.object(default_setting.var)
      #end
      #Rails::logger.info "SETTING: #{setting.inspect}"
      #setting
    #end
  #end



end

