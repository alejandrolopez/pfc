class CreateTableNoticias < ActiveRecord::Migration

  def self.up
    create_table :noticias do |t|
      t.column :title, :string
      t.column :summary, :text
      t.column :description, :text
      t.column :published_at, :datetime
      t.column :unpublished_at, :datetime
      t.column :published, :boolean
      t.column :cached_slug, :string
      t.column :num_visits, :integer, :default => 0
      t.column :site_id, :integer
      t.column :lang, :string, :size => 3
      t.timestamps
    end
  end

  def self.down
    drop_table :noticias
  end

end
