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

  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :password_confirmation, :role_ids, :signing_attributes, :as => :admin

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
