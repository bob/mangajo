module ActiveAdmin
  module Comments
    module Views
      class Comments < ActiveAdmin::Views::Panel
        def build_comment(comment)
          div :for => comment do
            div :class => "active_admin_comment_meta" do
              user_name = comment.author ? auto_link(comment.author) : "Anonymous"
              h4(user_name, :class => "active_admin_comment_author")
              span(pretty_format(comment.created_at))
            end
            div :class => "active_admin_comment_body" do
              simple_format(comment.body)
            end
            div :style => "clear:both;"
            div link_to "Edit comment", "/admin/active_admin_comments/#{comment.id}/edit"
          end
        end
      end
    end
  end
end
