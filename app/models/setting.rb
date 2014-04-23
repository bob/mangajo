class Setting < ActiveRecord::Base #RailsSettings::ScopedSettings
  attr_accessible :var, :value
  attr_accessor :title, :description, :hidden

  belongs_to :thing, :polymorphic => true

  validates :value, :presence => true
  before_save :is_ration_owner

  after_initialize :set_attrs

  def is_ration_owner
    if self.var == "ration"
      ration = Ration.find self.value
      if thing_type == "User" and thing_id != ration.user.id
        errors.add(:base, "You can choose as current only own ration")
        return false
      end
    end
  end

  def recalculate!
    if self.var == "weight"
      user = self.thing

      proteins_setting = user.setting_by_var("proteins") || user.settings.build(:var => "proteins")
      proteins_setting.value = self.value.to_f * 2
      proteins_setting.save

      fats_setting = user.setting_by_var("fats") || user.settings.build(:var => "fats")
      fats_setting.value = self.value.to_f * 0.5
      fats_setting.save

      carbs_setting = user.setting_by_var("carbs") || user.settings.build(:var => "carbs")
      carbs_setting.value = self.value.to_f * 4
      carbs_setting.save

    end
  end

  def set_attrs
    if self.var.present?
      self.title = get_conf_value(self.var, "title")
      self.description = get_conf_value(self.var, "description")
      self.hidden = get_conf_value(self.var, "hidden")
    end
  end

  def to_hash
    {"var" => self.var, "title" => self.title, "description" => self.description, "value" => self.value, "hidden" => self.hidden}
  end

  def get_conf_value(var_name, value_name)
    conf = Setting.default_conf
    conf[var_name][value_name]
  end

  def self.default_conf
    YAML.load_file("#{Rails.root}/config/default_settings.yml")
  end

  def self.from_hash(h)
    n = self.new
    n.var = h["var"]
    n.title = h["title"]
    n.description = h["description"]
    n.value = h["value"]
    n.hidden = h["hidden"]
    n
  end

end
