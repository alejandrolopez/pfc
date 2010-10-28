class CreateTableBooks < ActiveRecord::Migration

  def self.up
    create_table :books do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :cached_slug, :string
      t.column :site_id, :integer, :size => 11
      t.timestamps
    end

    create_table :authors_books, :id => false do |t|
      t.column :author_id, :integer, :size => 11
      t.column :book_id, :integer, :size => 11
    end

    add_index :authors_books, [:author_id, :book_id], :unique => true
  end

  def self.down
    drop_table :books
    drop_table :authors_books
  end

end