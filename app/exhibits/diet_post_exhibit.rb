require_relative 'exhibit'

class DietPostExhibit < Exhibit
  def render_body
    @context.render partial: "/home/diet", locals: { entry: self }
  end

  def self.applicable_to?(object)
    object.is_a?(Diet) #&& (!object.picture?)
  end

end


