class CreateTablePublishers < ActiveRecord::Migration

  def self.up
    create_table :publishers do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :web, :string
      t.column :email, :string
      t.column :address, :string
      t.column :cached_slug, :string
      t.column :num_visits, :integer, :default => 0
      t.timestamps
    end

    add_index :publishers, :cached_slug
    add_index :publishers, :name
  end

  def self.down
    drop_table :publishers
  end
end