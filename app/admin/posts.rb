ActiveAdmin.register Post do
  config.batch_actions = false
  config.clear_action_items!

  member_action :publish, :method => :post do
    if resource.publish!
      redirect_to request.referer, :notice => "Post published"
    else
      redirect_to request.referer, :alert => "Post NOT published. #{resource.errors.full_messages}"
    end
  end

  member_action :unpublish, :method => :post do
    resource.unpublish!
    redirect_to request.referer, :notice => "Post unpublished"
  end

  member_action :preview, :method => :get do
    render :template => "home/dish", :locals => {:entry => resource}, :layout => "application"
  end

  member_action :preview_short, :method => :get do
    @posts = [resource]
    render :template => "home/index", :layout => "application"
  end

  action_item :only => [:show] do
    postablec = resource.postable.class.name

    links = ''
    links += link_to I18n.t("links.#{postablec.downcase}", :default => postablec), eval("admin_#{postablec.downcase}_path(resource.postable)")
    links += link_to I18n.t("links.preview", :default => "Preview"), preview_admin_post_path(resource), :target => "_blank"
    links += link_to I18n.t("links.preview_short", :default => "Preview annotation"), preview_short_admin_post_path(resource), :target => "_blank"
    links += edit_delete_links(resource)
    links.html_safe
  end

  index do
    if current_user.admin?
      column :user
    end
    column :name do |c|
      auto_link c.postable, c.postable.name
    end
    column :postable_type
    column :published_at
    column :created_at

    column "" do |resource|
      html = ''

      if current_user.admin?
        if resource.published?
          html += link_to "Unpublish", unpublish_admin_post_path(resource), :method => :post, :class => "member_link"
        else
          html += link_to "Publish", publish_admin_post_path(resource), :method => :post, :class => "member_link"
        end
      end

      html += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link"
      html.html_safe
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs I18n.t("subtitles.details") do
      f.input :title
      f.input :short_description, :as => :ckeditor
    end

    f.actions

  end

  controller do
    #def show
      #redirect_to edit_admin_post_path(resource) and return
    #end

  end
end
