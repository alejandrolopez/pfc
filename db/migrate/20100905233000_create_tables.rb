class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :slugs do |t|
      t.string :name
      t.integer :sluggable_id
      t.integer :sequence, :null => false, :default => 1
      t.string :sluggable_type, :limit => 40
      t.string :scope
      t.datetime :created_at
    end

    add_index :slugs, :sluggable_id
    add_index :slugs, [:name, :sluggable_type, :sequence, :scope], :name => "index_slugs_on_n_s_s_and_s", :unique => true

    create_table :layouts do |t|
      t.string :name
      t.text :head
      t.text :body
      t.integer :site_id
      t.integer :visible, :default => 1
      t.integer :base, :default => 0

      t.timestamps
    end

    # Creamos la tabla de bloques
    create_table :blocks, :force => :true do |t|
      t.string :name
      t.integer :layout_id
      t.integer :element_id
      t.timestamps
    end

    # Creamos la tabla de elementos del cms
    create_table :elements, :force => :true do |t|
      t.string :name
      t.string :controller
      t.string :action
      t.timestamps
    end

    Element.create(:controller => "contents", :action => "show_content", :name => "Editor de texto")
    Element.create(:controller => "contents", :action => "show_content_estatico", :name => "Texto estatico")
    Element.create(:controller => "contents", :action => "show_migas", :name => "Migas")
    Element.create(:controller => "menu", :action => "menu_principal", :name => "Menu principal")
    Element.create(:controller => "menu", :action => "menu_secundario", :name => "Menu secundario")
    Element.create(:controller => "menu", :action => "menu_completo", :name => "Menu completo")
    Element.create(:controller => "noticias", :action => "last", :name => "Ultimas noticias")

    create_table :sites do |t|
      t.column :name, :string
      t.column :domain, :string
      t.column :value, :string
      t.timestamps
    end

    Site.create(:name => "localhost", :domain => "http://localhost", :value => "es")
    
#
#    # Creación de la tabla de caches
#    create_table :caches do |t|
#      t.string :path
#      t.string :controller
#      t.string :element
#      t.integer :site_id
#      t.timestamps
#    end
#
#    # Creamos la tabla de configuración
#    create_table :configurations do |t|
#      t.string :name
#      t.text :value
#      t.integer :borrable, :default => 1, :size => 1
#      t.integer :site_id
#      t.timestamps
#    end
#
#    # Se crean las basicas, y no se permite borrarlas
#    Configuration.create :name => "dominio", :value => "http://localhost", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "nombre_empresa", :value => "Localhost", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "nombre_proyecto", :value => "local", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "mail_contacto", :value => "alelop3z@gmail.com", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "mail_boletin", :value => "alelop3z@gmail.com", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "telefono_empresa", :value => "985123456", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "fax_empresa", :value => "985123456", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "localidad_empresa", :value => "Gijón", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "provincia_empresa", :value => "Principado de Asturias", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "direccion_empresa", :value => "Dirección", :borrable => 0, :site_id => Site.first.id
#    Configuration.create :name => "cp_empresa", :value => "33204", :borrable => 0, :site_id => Site.first.id
  end

  def self.down
    drop_table :slugs
    drop_table :sites
    drop_table :blocks
    drop_table :elements
    drop_table :layouts
    
#    drop_table :configurations
#    drop_table :caches
  end
end