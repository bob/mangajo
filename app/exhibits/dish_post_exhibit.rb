require_relative 'exhibit'

class DishPostExhibit < Exhibit
  def render_body
    @context.render partial: "/home/dish", locals: { entry: self }
  end

  def self.applicable_to?(object)
    object.is_a?(Dish) #&& (!object.picture?)
  end

end



