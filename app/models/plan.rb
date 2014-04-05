class Plan < ActiveRecord::Base
  attr_accessible :name, :description

  belongs_to :user
  has_many :plan_items, :dependent => :destroy


  def auto_weights!
    p "AUTO: proteins target: #{self.user.setting(:proteins)}"
    Meal.find_for(self.user.setting(:meals)).each do |m|
      p "Meal: #{m.id} #{m.name} #{Meal.meal_percents(m, self.user)}%"

      items = self.plan_items.where(:meal_id => m.id)

      items.each_with_index do |i, index|
        p "Item: #{i.dish.name}"
        # get how much proteins should be eated for this meal (equal for each dish), in gramms
        proteins_portion = Meal.meal_target(:proteins, m, user) / items.count
        p "Proteins portion: #{self.user.setting(:proteins).to_f} * #{Meal.meal_percents(m, self.user)} / 100 / #{items.count} = #{proteins_portion}g"

        # array of all ingredients percentage
        ing_percentages = i.ingredients_percentage

        # array of ingredients-with-protein percentage
        ing_protein_percentages = i.ingredients_with_protein_percentage

        item_weight = 0
        percentage_sum = 0
        # for each dish component with protein
        i.pi_ingredients_with_protein.each do |piing|
          # get proteins target portion
          proteins_target_portion = (ing_protein_percentages[piing.id] * proteins_portion / 100).round(2)
          p "Proteins target portion: #{proteins_target_portion}"

          # get weight new value (100 here is portion in gramms)
          weight_new = (proteins_target_portion * piing.ingredient.portion / piing.ingredient.proteins).round(2)
          p "Weight new value: #{weight_new}"

          piing.weight = weight_new
          piing.save

          item_weight += weight_new
          percentage_sum += ing_percentages[piing.id]
        end

        # check if there are ingredients without protein
        if i.pi_ingredients_without_protein.count > 0
          p "Ingredients with protein new weight: #{item_weight}"
          p "Percentage sum: #{percentage_sum}"

          # get new weight for all non-protein ingredients
          non_protein_weight = ((item_weight * 100 / percentage_sum) - item_weight).round(2)
          p "Non proteins weight: #{non_protein_weight}"

          # get non-protein ingredients percentage sum
          non_protein_percentage_sum = i.pi_ingredients_without_protein.map(&:id).sum{|id| ing_percentages[id]}
          p "Non proteins percentage sum: #{non_protein_percentage_sum}"

          # for each dish component without protein
          i.pi_ingredients_without_protein.each do |piing|
            # get target portion
            target_portion = ing_percentages[piing.id] * 100 / non_protein_percentage_sum
            p "Target portion: #{target_portion}"

            # get new weight
            weight_new = (target_portion * non_protein_weight / 100).round(2)
            p "New weight: #{weight_new}"

            # update plan_item_ingredient weight
            piing.weight = weight_new
            piing.save

            item_weight += weight_new
          end
        end

        i.weight = item_weight
        i.save

      end

    end
  end

  def total_kcal
    res = 0
    Meal.find_for(self.user.setting(:meals)).each do |m|
      res += self.meal_total_kcal(m)
    end
    res
  end

  def meal_total_kcal(meal)
    res = 0
    self.plan_items.where(:meal_id => meal.id).each do |i|
      res += i.calculate_kcal_weight(i.weight).to_f
    end
    res.round(2)
  end

  def total_weight
    res = 0
    Meal.find_for(self.user.setting(:meals)).each do |m|
      res += self.meal_total_weight(m)
    end
    res
  end

  def meal_total_weight(meal)
    res = 0
    self.plan_items.where(:meal_id => meal.id).each do |i|
      res += i.weight.to_f
    end
    res.round(2)
  end

  def total_nutrition(nutrient)
    res = 0
    Meal.find_for(self.user.setting(:meals)).each do |m|
      res += self.meal_total_nutrition(nutrient, m)
    end
    res
  end

  def meal_total_nutrition(nutrient, meal)
    res = 0
    self.plan_items.where(:meal_id => meal.id).each do |i|
      res += i.calculate_nutrient_weight(nutrient, i.weight)
    end
    res
  end
end
