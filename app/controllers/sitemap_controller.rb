class SitemapController < ApplicationController
  layout false
  respond_to :html, :xml

  def index
    headers['Content-Type'] = 'application/xml'
    last_post = Diet.last
    @posts = Diet.published

    if stale?(:etag => last_post, :last_modified => last_post.updated_at.utc)
      respond_to do |format|
        format.html {}
        format.xml { @posts = Diet.published }
      end
    end
  end
end
