class HomeController < ApplicationController
  before_filter :side_posts

  def index
    @posts = Post.published
  end

  def post
    @post = Post.published.friendly.find(params[:post_id])
  end

  private
  def side_posts
    @side_posts = Post.published.limit(7)
  end
end
