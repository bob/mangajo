class Diet < ActiveRecord::Base
  attr_accessible :name, :description, :diet_items_attributes

  belongs_to :user

  has_many :diet_items
  accepts_nested_attributes_for :diet_items, :allow_destroy => true

  scope :published, -> { where.not(:published_at => nil).order("published_at DESC") }

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
