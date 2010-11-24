class CreateTableAuthors < ActiveRecord::Migration

  def self.up
    create_table :authors do |t|
      t.column :name, :string
      t.column :surname1, :string
      t.column :surname2, :string
      t.column :description, :text
      t.column :country_id, :integer
      t.column :email, :string
      t.column :web, :string
      t.column :cached_slug, :string
      t.timestamps
    end

    add_index :authors, :cached_slug
    add_index :authors, [:name, :surname1, :surname2]
  end

  def self.down
    drop_table :authors
  end
  
end