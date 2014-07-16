module HomeHelper
  include ActiveAdmin::ViewsHelper
  include ISO8601

  def duration_iso8601(value)
    (Duration.new(value.to_i) + Duration.new(0)).to_s
  end

  def duration_localed(value)
    return 0 unless value.to_i > 0

    res = nil
    durations_array(600).map{ |a| res = a[0] if a[1] == value }
    res
  end

  def published_datetime(post)
    html = ''
    html += content_tag :span, "", :class => "glyphicon glyphicon-time"
    html += " #{I18n.t(:published)} "

    publish_date = post.published_at.presence || ::Time.now
    html += content_tag :time, l(publish_date, :format => :long), :datetime => publish_date.to_s(:db), :itemprop => "published"

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

  def ingredient_quantity(ingredient)
    if ingredient.portion_unit == "item"
      res = "#{nice_float(ingredient.portions)}&nbsp;#{I18n.t("item_abbr")}"
    else
      res = "#{nice_float(ingredient.weight)}&nbsp;#{I18n.t("gramm_abbr")}"
    end
    res.html_safe
  end

  def nice_float(float)
    (float == float.floor) ? float.to_i : float.round(2)
  end
end
