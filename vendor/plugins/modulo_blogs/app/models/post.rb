class Post < ActiveRecord::Base

  acts_as_commentable

  validates :title, :presence => true
  validates :summary, :presence => true
  validates :description, :presence => true

  belongs_to :blog
  before_validation :check_dates
  before_save :published_or_not

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true, :scope => :blog

  def initialize(*params)
    super(*params)

    if @new_record
      self.published_at ||= Time.now
      self.unpublished_at ||= Time.now
    end
  end

  def self.find_published(blog, order = nil, limit = nil)
    @posts = Post.where(["blog_id = ? and published = ?", blog, 1])
    @posts = @posts.order(order) unless order.blank?
    @posts = @posts.limit(limit) unless limit.blank?
    @posts
  end

  # Funcion que obtiene los comentarios válidos
  # Si no llega usuario sacamos los que son validos
  # Los ordenamos por defecto con created_at y por ultimo sacamos el número que elijamos
  def comments_validos(user = nil, limit = nil, order = "created_at DESC")
    @comments = self.comments
    @comments = @comments.where("status != 2") if user.blank?
    @comments = @comments.order(order)
    @comments = @comments.limit(limit) unless limit.blank?
    @comments
  end

  # Devuelve si es publico o no según la fecha
  def published?
    (self.published_at <= Time.now and self.unpublished_at > Time.now) ? true : false
  end

  private

    def check_dates
      if self.unpublished_at <= self.published_at
        errors.add("published_at", I18n.t("post.published_at_more_less_than_unpublished_at"))
      end
    end

    # Validacion de si la noticia debe publicarse o no
    def published_or_not
      self.published = (self.published_at <= Time.now and self.unpublished_at >= Time.now) ? 1 : 0
    end

    # Recorremos todas las noticias y comprobamos su fecha (con guardar sirve para que se realice la validacion)
    def self.publish_posts
      Post.where("published = 1").collect(&:save)
    end

end