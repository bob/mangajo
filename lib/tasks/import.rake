# encoding: utf-8
require 'rake/packagetask'

namespace :import do

  desc "Imports default ingredients from given CSV file"
  task(:ingredients => :environment) do
    require 'csv'

    ration = Ration.get_default
    groups = {}
    CSV.parse(File.open("#{Rails.root}/lib/assets/racion_only.csv", 'rb')) do |row|
      name = row[0]
      name = name.force_encoding("UTF-8")

      portion = row[1]
      proteins = row[2]
      fats = row[3]
      carbs = row[4]

      group = row[6]
      group = group.force_encoding("UTF-8").mb_chars.capitalize

      unless groups.include? group
        ingroup = IngredientGroup.find_or_create_by_name(group)
        groups[group] = ingroup.id
      end

      puts "#{group}. #{name} - #{proteins}, #{fats}, #{carbs}"

      ing = Ingredient.new
      ing.user = ration.user
      ing.ration = ration
      ing.ingredient_group_id = groups[group]
      ing.name = name
      ing.portion = portion
      ing.portion_unit = 'gramm'
      ing.proteins = proteins
      ing.fats = fats
      ing.carbs = carbs
      ing.save!

    end
  end

end

