module ApplicationHelper
  def yield_with_default(name, default, joins = ", ")
    if content_for?(name)
      [content_for(name).chomp, default].join(joins)
    else
      default
    end
  end
end
