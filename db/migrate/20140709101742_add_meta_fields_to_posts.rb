class AddMetaFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :meta_keywords, :text, :limit => 1024
    add_column :posts, :meta_description, :text, :limit => 1024
  end
end
