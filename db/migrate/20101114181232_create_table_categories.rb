class CreateTableCategories < ActiveRecord::Migration

  def self.up
    create_table :categories do |t|
      t.column :name, :string
      t.column :parent_id, :integer, :size => 11, :default => 0
      t.column :cached_slug, :string
      t.timestamps
    end
    
    add_index :categories, :cached_slug

    create_table :books_categories, :id => false do |t|
      t.column :book_id, :integer, :size => 11
      t.column :category_id, :integer, :size => 11
    end

    add_index :books_categories, [:book_id, :category_id]
    add_index :books_categories, :category_id
  end

  def self.down
    drop_table :categories
    drop_table :books_categories
  end

end