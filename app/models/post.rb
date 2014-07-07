class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :postable, :polymorphic => true
  attr_accessible :title, :short_description

  scope :published, -> { where.not(:published_at => nil).order("published_at DESC") }

  attr_accessor :blog

  def published?
    !self.published_at.nil?
  end

  def publish!(clock = DateTime)
    return false unless valid?

    self.published_at = clock.now
    self.save
  end

  def unpublish!
    self.published_at = nil
    self.save
  end

end
