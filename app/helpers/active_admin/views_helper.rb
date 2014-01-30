module ActiveAdmin::ViewsHelper #camelized file name
  def params_day_date
    (params[:d] || Date.today).to_date
  end
end
