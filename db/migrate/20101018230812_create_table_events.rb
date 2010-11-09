class CreateTableEvents < ActiveRecord::Migration

  def self.up
    create_table :events do |t|
      t.column :title, :string
      t.column :summary, :text
      t.column :description, :text
      t.column :published_at, :datetime
      t.column :unpublished_at, :datetime
      t.column :published, :integer, :size => 1
      t.column :init_date, :datetime
      t.column :finish_date, :datetime
      t.column :cached_slug, :string
      t.column :num_visits, :integer, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end

end
