class Noticia < ActiveRecord::Base

  acts_as_commentable

  validates :title, :presence => true
  validates :summary, :presence => true
  validates :description, :presence => true

  before_validation :check_dates
  before_save :published_or_not

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true

  def initialize(*params)
    super(*params)

    if @new_record
      self.published_at ||= Time.now
      self.unpublished_at ||= Time.now
    end
  end

  # Busca las noticias publicadas
  def self.find_published(limit = nil)
    @noticias = Noticia.where("published = 1")
    @noticias.limit(limit) unless limit.blank?
    @noticias
  end

  # Funcion que obtiene los comentarios válidos
  # Si no llega usuario sacamos los que son validos
  # Los ordenamos por defecto con created_at y por ultimo sacamos el número que elijamos
  def comments_validos(limit = nil, order = "created_at DESC")
    @comments = self.comments
    @comments = @comments.where("status != 2")
    @comments = @comments.order(order)
    @comments = @comments.limit(limit) unless limit.blank?
    @comments
  end

  # Devuelve si es publico o no según la fecha
  def published?
    (self.published_at <= Time.now and self.unpublished_at > Time.now) ? true : false
  end

  # Aumentar el numero de visitas a una noticia
  def add_visit
    self.update_attribute(:num_visits, self.num_visits + 1)
  end

  private
  
    # Metodo para comprobar si la fecha de caducidad es inferior a la de publicacion
    def check_dates
      if self.unpublished_at <= self.published_at
        errors.add("published_at", I18n.t("noticia.published_at_more_less_than_unpublished_at"))
      end
    end

    # Validacion de si la noticia debe publicarse o no
    def published_or_not
      self.published = published?
    end

    # Recorremos todas las noticias y comprobamos su fecha (con guardar sirve para que se realice la validacion)
    def self.publish_news
      Noticia.all.collect(&:save)
    end

end