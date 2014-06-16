class Diet < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name, :description, :diet_items_attributes

  belongs_to :user

  has_many :diet_items
  accepts_nested_attributes_for :diet_items, :allow_destroy => true

  scope :published, -> { where.not(:published_at => nil).order("published_at DESC") }

  def should_generate_new_friendly_id?
    name_changed?
  end

  def published?
    self.published_at.present?
  end

  def publish(clock=DateTime)
    return false unless valid?

    self.published_at = clock.now
    self.save
  end

  def unpublish
    self.published_at = nil
    self.save
  end
end
