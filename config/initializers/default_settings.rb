conf = YAML.load_file("#{Rails.root}/config/default_settings.yml")

conf.values.each do |c|
  #Setting[c["var"].to_sym] = c
end

#Setting.save_default(:some_key, "123")
