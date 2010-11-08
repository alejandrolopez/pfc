class CreateTableCritics < ActiveRecord::Migration

  def self.up
    create_table :critics do |t|
      t.column :title, :string
      t.column :summary, :text
      t.column :description, :text
      t.column :author, :string
      t.column :cached_slug, :string
      t.column :num_visits, :integer, :default => 0
      t.column :published, :boolean, :default => false
      t.column :book_id, :integer, :size => 11
      t.column :user_id, :integer, :size => 11
      t.column :published_at, :datetime
      t.column :status, :integer, :size => 1, :default => 0
      t.timestamps
    end

    add_index :critics, :book_id
    add_index :critics, :user_id
  end

  def self.down
    drop_table :critics
  end

end