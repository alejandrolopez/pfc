class AddStatusToComments < ActiveRecord::Migration

  def self.up
    add_column :comments, :status, :integer, :default => 0
    add_column :comments, :author, :string
    add_column :comments, :email, :string
  end

  def self.down
    remove_column :comments, :status
    remove_column :comments, :author
    remove_column :comments, :email
  end

end
