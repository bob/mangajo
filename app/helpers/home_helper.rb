module HomeHelper
  def published_datetime(post)
    html = ''
    html += content_tag :span, "", :class => "glyphicon glyphicon-time"
    html += " #{I18n.t(:published)} #{l(post.published_at, :format => :long)}"
    html.html_safe
  end

  def plan_item_quantity(item)
    if item.plan_item_ingredients.count == 1
      pi = item.plan_item_ingredients[0]
      if pi.ingredient.portion_unit == "item"
        "#{pi.portion.round(2)} #{I18n.t("item_abbr")}"
      else
        "#{pi.weight.round(2)} #{I18n.t("gramm_abbr")}"
      end
    else
      "#{item.weight.round(2)} #{I18n.t("gramm_abbr")}"
    end
  end
end
