class CreateTableWalls < ActiveRecord::Migration

  def self.up
    create_table :walls do |t|
      t.column :user_id, :integer, :size => 11
      t.timestamps
    end

    add_index :walls, :user_id

    create_table :entries do |t|
      t.column :message, :text
      t.column :wall_id, :integer, :size => 11
      t.column :user_id, :integer, :size => 11
      t.timestamps
    end

    add_index :entries, :wall_id
    add_index :entries, [:wall_id, :user_id]
  end

  def self.down
    drop_table :entries
    drop_table :walls
  end

end