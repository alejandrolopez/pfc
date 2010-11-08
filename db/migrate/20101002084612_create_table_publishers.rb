class CreateTablePublishers < ActiveRecord::Migration

  def self.up
    create_table :publishers do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :web, :string
      t.column :email, :string
      t.column :address, :string
      t.column :cached_slug, :string
      t.column :lang, :string, :size => 3
      t.column :site_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :publishers
  end
end