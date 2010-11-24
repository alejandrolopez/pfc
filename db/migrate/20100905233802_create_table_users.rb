class CreateTableUsers < ActiveRecord::Migration
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
    
    create_table :users do |t|
      t.string :login
      t.string :name
      t.string :surname1
      t.string :surname2
      t.string :email
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.string :activation_code, :limit => 40
      t.datetime :activated_at
      t.string :cached_slug
      t.boolean :system, :default => 0
      t.timestamps
    end

    m = User.new :login => "admin", :password => "admin", :name => "Admin", :surname1 => "Admin", :surname2 => "Admin", :email => "alelop3z@gmail.com", :system => true
    m.activate

    # Creamos los grupos
    create_table :groups do |t|
      t.string :name
      t.text :description
      t.string :cached_slug
      t.boolean :system, :default => 0
      t.timestamps
    end

    g = Group.new :name => "Administradores", :description => "Grupo de los administradores", :system => true
    g.save(false)

    # Creamos la tabla asociada
    create_table :groups_users, :id => false do |t|
      t.column :group_id, :integer
      t.column :user_id, :integer
    end

    # Añadimos el usuario administrador al grupo administrador
    @user = User.find(:first)
    @group = Group.find(:first)
    @group.users << @user
  end

  def self.down
    drop_table :groups_users
    drop_table :groups
    drop_table :users
    drop_table :entries
    drop_table :walls
  end
end
