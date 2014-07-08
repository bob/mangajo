module ActiveAdmin
  module PostAction

    def self.included(base)

      base.instance_eval do
        resource_name = self.config.resource_class.name.split('::').last.downcase

        member_action "post_#{resource_name}".to_sym, :method => :post do
          if resource.post
            redirect_to admin_post_path(resource.post) and return
          end

          post = @blog.new_post(resource)
          if post.save
            redirect_to edit_admin_post_path(post), :notice => "Post created."
          else
            redirect_to eval("admin_#{resource_name}_path(resource)"), :alert => "Post NOT created. #{post.errors.full_messages}"
          end
        end

      end

    end # self.included

    def self.new_path(name)
      "post_#{name}_admin_#{name}_path"
    end


  end

  module ActiveAdmin::ViewsHelper

    def post_action_link(resource)
      resource_name = resource.class.name.downcase

      if resource.post
        link_to I18n.t("links.edit_post", :default => "Edit post"), edit_admin_post_path(resource.post)
      else
        link_to I18n.t("links.create_post", :default => "Create post"), eval("#{ActiveAdmin::PostAction.new_path(resource_name)}(resource)"), :method => :post, :data => {:confirm => I18n.t("links.confirm_publish")}
      end
    end

  end




end
