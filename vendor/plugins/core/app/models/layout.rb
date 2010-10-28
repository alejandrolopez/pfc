class Layout < ActiveRecord::Base

  validates :name, :presence => true
  validates :body, :presence => true

  belongs_to :site
  has_many :blocks

  after_save :update_layout
  after_destroy :delete_layout

  def validate
    self.errors[:base] << I18n.t("layout.exists_for_site") if check_name_and_site(self.name, self.site_id) and new_record?
  end

  def self.find_layouts_del_site(site)
    Layout.find(:all, :conditions => ["site_id = ?", site])
  end

  # Array de layuts visibles
  def self.find_visibles_del_site(site)
    Layout.find_all_by_visible_and_site_id(1, site)
  end

  # Borra el layout
  def delete_layout
    File.delete("app/views/layouts/" + self.site_id.to_s + "_" + self.name + ".erb")
  end

  def update_layout
    f = File.open("app/views/layouts/" + self.site_id.to_s + "_" + self.name + ".erb", "w") do |file|

    file << %{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      <head>
        <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
        <title><%= session[:title] %></title>

        <%= stylesheet_link_tag 'base', 'public', 'jquery-ui.css', 'jquery.Jcrop', :media => 'screen, print' %>
        <%= javascript_include_tag :defaults, 'jquery.colorbox-min.js' %>
        <%= csrf_meta_tag %>

        <% if session[:user_id] %>
          <%= javascript_include_tag 'nicEdit', 'jquery.Jcrop.min' %>
        <% end -%>
        }

    file << self.head

    file << %{
    <meta name="resource-type" content="document" />
    <meta name="robots" content="all" />
    <meta name="revisit-after" content="30 days" />}

    file << %{
      </head>
      <body>
        <% if session[:user_id] %>
          <%= render :partial => 'comun/menu_admin' %>
        <% end %>
      }

    file << update_blocks(self.body)

    file << %{
    </body>
  </html>
    }
    end
  end

  def update_blocks(texto)
    antiguos_bloques = self.blocks # bloques que ya existian en el layout antes de guardar
    nuevos_bloques = [] # bloques iguales o nuevos que se van a almacenar

    # Actualizamos el texto eliminando los espacios en blanco de la llamada block
    texto = texto.gsub('<@ block', '<@block').gsub(' @>', '@>')

    # Cortamos el texto para dividir block por el element que le corresponda
    bloques = texto.split('<@block')
    new_text = ""

    bloques.size.times do |i|
      if bloques[i].include?('@>')
        subbloque = bloques[i].split('@>')
        nombre = subbloque[0].strip

        #si es el contenedor default añado el yield
        if nombre.include? 'default'
          nombre = nombre.gsub('default','').strip
            new_text << '<%= yield :' + nombre + ' %>'
            new_text << '<%= yield %>'
        else
          new_text << '<%= yield :' + nombre + ' %>'
        end
        new_text << subbloque[1] if subbloque[1]

        #miro si el bloque existe y si no lo creo
        b = self.blocks.find_by_name(nombre)

        unless b
          # por defecto le asignamos un elemento de la base de datos y le damos el nombre que corresponda
          nuevos_bloques << Block.new(:element_id => 1, :name => nombre)
        else
          nuevos_bloques << b
        end

      else
        new_text += bloques[i]
      end
    end

    self.blocks << nuevos_bloques.flatten

    # Calculamos los bloques que ya no se utilizan de entre los bloques que se usaban y los nuevos bloques que se usan
    bloques_sobrantes = antiguos_bloques - nuevos_bloques

    # Eliminamos los bloques que sobran
    bloques_sobrantes.collect(&:destroy)

    return new_text
  end

  private

    # Compruebo si existe el nombre y site para este layout
    def check_name_and_site(name, site)
      return !Layout.where(["name = ? and site_id = ?", name, site]).first.blank?
    end
end