class Book < ActiveRecord::Base

  acts_as_commentable

  belongs_to :site
  has_and_belongs_to_many :authors, :order => "name ASC, surname1 ASC, surname2 ASC"

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true

  validates :title, :presence => true
  validates :description, :presence => true

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

end