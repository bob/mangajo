class HomeController < ApplicationController
  def index
    @diets = Diet.published
  end
end
