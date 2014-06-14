class Meal < ActiveRecord::Base
  has_no_table :database => :pretend_success
  column :id, :integer
  column :name, :string
  column :key, :string

  attr_accessible :id, :name, :key

  class << self
    def meal_target(nutrient, meal, user, meals_num)
      if nutrient == :carbs
        a = self.carbs_allocation_presets(meals_num)
        percents = a[meal.id]
      else
        percents = self.meal_percents(meal, meals_num)
      end
      (user.setting(nutrient).to_f * percents / 100).round(2)
    end

    def meal_percents(meal, meals_num)
      a = self.allocation_presets(meals_num)
      a[meal.id]
    end

    def meal_time(meal, user)
      start = Time.parse(user.setting(:breakfast_time))
      case meal.id
      when 1
        start
      when 2
        start + 3.hours
      when 3
        start + 6.hours
      when 4
        start + 9.hours
      when 5
        start + 12.hours
      when 6
        start + 15.hours
      else
        nil
      end
    end

    def carbs_allocation_presets(quan)
      case quan.to_i
      when 1
        q = {1 => 100}
      when 2
        q = {1 => 40, 2 => 60}
      when 3
        q = {1 => 40, 3 => 60, 5 => 0}
      when 4
        q = {1 => 40, 3 => 60, 4 => 0, 5 => 0}
      when 5
        q = {1 => 20, 2 => 10, 3 => 60, 4 => 10, 5 => 0}
      when 6
        q = {1 => 20, 2 => 10, 3 => 60, 4 => 10, 5 => 0, 6 => 0}
      else
        raise "Meals quantity incorrect"
      end
    end

    def allocation_presets(quan)
      case quan.to_i
      when 1
        q = {1 => 100}
      when 2
        q = {1 => 40, 2 => 60}
      when 3
        q = {1 => 30, 3 => 45, 5 => 25}
      when 4
        q = {1 => 25, 3 => 35, 4 => 15, 5 => 25}
      when 5
        q = {1 => 20, 2 => 10, 3 => 40, 4 => 20, 5 => 10}
      when 6
        q = {1 => 20, 2 => 10, 3 => 30, 4 => 15, 5 => 20, 6 => 5}
      else
        raise "Meals quantity incorrect"
      end
    end

    def find_for(quan)
      q = self.allocation_presets(quan).keys
      self.find(q)
    end

    def find_by_sql(*args)
      records
    end

    def find(id)
      if id.instance_of? Array
        res = []
        id.each do |i|
          res << self.find(i)
        end
        res
      else
        records.find{ |r| r.id == id.to_i }
      end
    end

    def records
      [
        Meal.new(:id => 1, :name => "Breakfast", :key => "breakfast"),
        Meal.new(:id => 2, :name => "Second breakfast", :key => "second_breakfast"),
        Meal.new(:id => 3, :name => "Dinner", :key => "dinner"),
        Meal.new(:id => 4, :name => "Tea", :key => "tea"),
        Meal.new(:id => 5, :name => "Supper", :key => "supper"),
        Meal.new(:id => 6, :name => "Second supper", :key => "second_supper")
      ]
    end

  end

end
