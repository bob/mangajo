class HomeController < ApplicationController
  def index
    @diets = Diet.published
    @side_diets = @diets[0..6]
  end

  def post
    @diet = Diet.published.find(params[:post_id])
    @side_diets = Diet.published.limit(7)
  end
end
