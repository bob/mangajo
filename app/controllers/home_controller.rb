class HomeController < ApplicationController
  def index
    @posts = Post.published
    @side_posts = @posts[0..6]
  end

  def post
    @diet = Diet.published.friendly.find(params[:post_id])
    @side_diets = Diet.published.limit(7)
  end

  def dish

  end
end
