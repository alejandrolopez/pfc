class Site < ActiveRecord::Base

  validates :name, :presence => true
  validates :domain, :presence => true
  validates :value, :presence => true

  has_many :layouts
  has_many :blogs
  has_many :authors
  has_many :noticias

  before_save :clean_domain
  after_create :create_base
    
  def domain_without_http
    domain.gsub("http://", "")
  end

  def self.devuelve_site(site = nil)
    site = Site.find(:first, :select => "id", :conditions => ["domain = ?", site.gsub("https://", "http://")]) unless site.blank?

    # Devuelvo el primer site si no encuentra ninguno o si llega nulo
    return Site.first.id if site.blank?
    site
  end

  private

    def crear_layouts_base
      Layout.create(:name => "main", :body => "<%= yield %>", :visible => 1, :base => 1, :site_id => self.id)
    end

    # Creo las carpetas base de cada site
    # Esas carpetas son las de imagenes, javascripts, stylesheets
    def crear_carpetas_base
      if !File.exists?(Rails.root.to_s + "/public#{self.id}")
        FileUtils.mkdir(Rails.root.to_s + "/public#{self.id}")
        FileUtils.mkdir(Rails.root.to_s + "/public#{self.id}/images")
        FileUtils.mkdir(Rails.root.to_s + "/public#{self.id}/javascripts")
        FileUtils.mkdir(Rails.root.to_s + "/public#{self.id}/stylesheets")
      end
    end

    def clean_domain
      self.domain = self.domain.starts_with?("http://") ? self.domain : ("http://" + self.domain.gsub("https://", ""))
    end

    def create_base
      crear_carpetas_base
      crear_layouts_base
    end
end