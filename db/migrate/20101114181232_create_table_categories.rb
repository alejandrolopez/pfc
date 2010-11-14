class CreateTableCategories < ActiveRecord::Migration

  def self.up
    create_table :categories do |t|
      t.column :name, :string
      t.column :cached_slug, :string
      t.timestamps
    end

    add_column :books, :category_id, :integer, :size => 11
    add_index :books, :category_id
  end

  def self.down
    remove_index :books, :category_id
    remove_column :books, :category_id
    drop_table :categories
  end

end