class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :settings, :as => :thing
  has_many :eatens, :dependent => :destroy
  has_many :plans, :dependent => :destroy
  has_many :own_rations, :class_name => Ration, :dependent => :destroy
  has_and_belongs_to_many :shared_rations, :class_name => Ration
  has_many :dishes, :dependent => :destroy
  has_many :ingredients, :dependent => :destroy
  has_many :diets, :dependent => :destroy

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :password_confirmation, :role_ids, :signing_attributes, :as => :admin

  after_create :add_rations

  def admin?
    has_role?(:admin)
  end

  def add_rations
    def_ration = Ration.get_default
    def_ration.customers << self
    def_ration.save

    ration = Ration.new
    ration.user = self
    ration.name = "My ration"
    ration.save

    setting = self.settings.build(:var => "ration")
    setting.value = ration.id
    setting.save
  end

  def all_diets
    self.admin? ? Diet.all : diets
  end

  def all_plans
    self.admin? ? Plan.all : plans
  end

  def all_rations
    #(self.own_rations + self.shared_rations).sort! {|x,y| x.created_at <=> y.created_at} #=> accesible_by error
    #self.own_rations.merge(self.shared_rations) # => empty result

    #TODO should refactor to direct SQL query
    temp = self.own_rations + self.shared_rations
    Ration.where('id in (?)',temp.map(&:id)).order("created_at DESC")
  end

  def all_dishes
    Dish.by_ration_and_own(self.setting(:ration), self)
  end

  def all_ingredients
    Ingredient.by_ration_and_own(self.setting(:ration), self)
  end

  def setting(var)
    var = var.to_s
    var_setting = self.setting_by_var(var)
    return var_setting.value if var_setting

    conf = Setting.default_conf
    conf[var]["value"]
  end

  def full_settings
    conf = Setting.default_conf
    user_settings = self.settings.to_a
    res = []

    conf.values.each do |c|
      s = setting_by_var(c["var"], user_settings)
      s = Setting.from_hash(c) unless s
      res << s
    end

    res
  end

  def setting_by_var(var, collection = nil)
    collection ||= self.settings.to_a
    collection.each do |c|
      return c if c.var == var
    end
    nil
  end

end
