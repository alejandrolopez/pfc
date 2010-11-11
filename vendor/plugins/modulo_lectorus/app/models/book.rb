class Book < ActiveRecord::Base

  acts_as_commentable

  has_many :critics, :order => "created_at DESC"
  has_and_belongs_to_many :authors, :order => "name ASC, surname1 ASC, surname2 ASC"
  has_and_belongs_to_many :publishers, :order => "name ASC"

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true

  validates :title, :presence => true
  validates :description, :presence => true

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