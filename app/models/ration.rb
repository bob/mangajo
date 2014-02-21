class Ration < ActiveRecord::Base
  belongs_to :user
  has_many :ingredients
  has_and_belongs_to_many :customers, :class_name => User
  attr_accessible :name, :description

  validate :name, :presence => true

  # we check if deleting ration currently selected in settings
  # if yes, then switch setting to default ration
  # assuming that user deleting his own ration
  before_destroy :check_setting

  def check_setting
    if self.user and self.user.setting(:ration).to_i == self.id
      Ration.set_setting_to_default(self.user)
    end
  end

  class << self
    def set_setting_to_default(user)
      user.setting_by_var("ration").update_attribute(:value, Ration.get_default.id)
    end

    def get_default
      Ration.find(1)
    end
  end
end
