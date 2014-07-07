module HomeHelper
  def published_datetime(post)
    html = ''
    html += content_tag :span, "", :class => "glyphicon glyphicon-time"
    html += " #{I18n.t(:published)} #{l(post.published_at.presence || Time.now, :format => :long)}"
    html.html_safe
  end

  def plan_item_quantity(item)
    if item.plan_item_ingredients.count == 1
      pi = item.plan_item_ingredients[0]
      if pi.ingredient.portion_unit == "item"
        res = "#{nice_float(pi.portion)}&nbsp;#{I18n.t("item_abbr")}"
      else
        res = "#{nice_float(pi.weight)}&nbsp;#{I18n.t("gramm_abbr")}"
      end
    else
      res = "#{nice_float(item.weight)}&nbsp;#{I18n.t("gramm_abbr")}"
    end
    res.html_safe
  end

  def nice_float(float)
    (float == float.floor) ? float.to_i : float.round(2)
  end
end
