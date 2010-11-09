class CreateTableBooks < ActiveRecord::Migration

  def self.up
    create_table :books do |t|
      t.column :title, :string
      t.column :summary, :text
      t.column :description, :text
      t.column :cached_slug, :string
      t.column :num_visits, :integer, :default => 0
      t.timestamps
    end

    create_table :authors_books, :id => false do |t|
      t.column :author_id, :integer, :size => 11
      t.column :book_id, :integer, :size => 11
    end

    add_index :authors_books, [:author_id, :book_id], :unique => true

    create_table :books_publishers, :id => false do |t|
      t.column :book_id, :integer, :size => 11
      t.column :publisher_id, :integer, :size => 11
    end

    add_index :books_publishers, [:book_id, :publisher_id], :unique => true
  end

  def self.down
    drop_table :books
    drop_table :authors_books
    drop_table :books_publishers
  end

end