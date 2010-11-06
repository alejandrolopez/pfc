class CreateTableCritics < ActiveRecord::Migration

  def self.up
    create_table :critics do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :cached_slug, :string
      t.column :num_visits, :integer, :default => 0
      t.column :book_id, :integer, :size => 11
      t.timestamps
    end

    add_index :critics, :book_id
  end

  def self.down
    drop_table :critics
  end

end