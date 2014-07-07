class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :short_description
      t.integer :postable_id
      t.string :postable_type, :limit => 50
      t.datetime :published_at

      t.timestamps
    end
  end
end
