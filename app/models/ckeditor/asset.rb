class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase

  belongs_to :assetable, polymorphic: true

  delegate :url, :current_path, :content_type, :to => :data

  validates_presence_of :data
end
