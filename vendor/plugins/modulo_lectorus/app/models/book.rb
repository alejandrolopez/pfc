class Book < ActiveRecord::Base

  acts_as_commentable

  has_many :critics, :order => "created_at DESC"
  has_and_belongs_to_many :authors, :order => "name ASC, surname1 ASC, surname2 ASC", :uniq => true
  has_and_belongs_to_many :publishers, :order => "name ASC", :uniq => true
  has_and_belongs_to_many :categories, :order => "name ASC", :uniq => true

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true

  validates :title, :presence => true
  validates :description, :presence => true
  validates :published_year, :numericality => true, :unless => :published_year_is_blank?

  before_validation :validates_published_year

  # Devuelve true si el campo published_year es blanco (lo uso para las validaciones)
  def published_year_is_blank?
    return self.published_year.blank?
  end

  # Valido si el campo introducido es un año o no
  # Si no es vacio compruebo que es un numero de 4 cifras (si es numero se comprueba en la validación superior)
  def validates_published_year
    unless self.published_year.blank?
      errors.add(I18n.t("published_year"), I18n.t("not_year")) if self.published_year.size != 4
    end
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

  # Devuelvo el listado de las últimas criticas
  def critics_validas(limit = nil, order = "created_at DESC")
    @critics = self.critics
    @critics = @critics.where(["published = ? and status != ?", 1, 2])
    @critics  =@critics.select("id, title, summary, published_at").order(order)
    @critics = @critics.limit(limit) unless limit.blank?
    @critics
  end

  # Devuelvo la lista de ids del autor
  def author_ids
    authors.collect(&:id).join(",")
  end

  # Adjunto a la lista de autores del libro los ids capturados en el formulario
  def author_ids=(value)
    if value != self.authors.collect(&:author_id).join(",")
      self.authors.clear
      array_values = value
      array_values = value.split(",") if value.is_a?(String)
      array_values.each do |elto|
        begin
          self.authors << Author.find(elto)
        rescue
          nil
        end
      end
    end
  end

  # Devuelvo la lista de ids de editoriales
  def publisher_ids
    publishers.collect(&:id).join(",")
  end

  # Adjunto a la lista de editoriales del libro los ids capturados en el formulario
  def publisher_ids=(value)
    if value != self.publishers.collect(&:publisher_id).join(",")
      self.publishers.clear
      array_values = value
      array_values = value.split(",") if value.is_a?(String)
      array_values.each do |elto|
        begin
          self.publishers << Publisher.find(elto)
        rescue
          nil
        end
      end
    end
  end

end