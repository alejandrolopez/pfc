class CreateTableBlogs < ActiveRecord::Migration

  def self.up
    create_table :blogs do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :cached_slug, :string
      t.column :site_id, :integer
      t.column :lang, :string, :size => 3
      t.timestamps
    end

    create_table :posts do |t|
      t.column :title, :string
      t.column :summary, :text
      t.column :description, :text
      t.column :blog_id, :integer
      t.column :published_at, :datetime
      t.column :unpublished_at, :datetime
      t.column :published, :boolean
      t.column :cached_slug, :string
      t.column :num_visits, :integer, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
    drop_table :posts
  end

end