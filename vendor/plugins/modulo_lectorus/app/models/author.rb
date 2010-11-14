class Author < ActiveRecord::Base

  acts_as_commentable

  validates :name, :presence => true
  validates :surname1, :presence => true
  validates :description, :presence => true
  # Valido el formato del email siempre que este campo no esté en blanco con la funcion email_not_blank?
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }, :if => :email_not_blank?

  belongs_to :country

  has_and_belongs_to_many :books, :order => "title ASC"

  before_save :clean_http_web

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true

  def complete_name
    self.name.to_s + " " + self.surname1.to_s + " " + self.surname2.to_s
  end

  def self.find_all_authors
    @authors = Author.select("id, name, surname1, surname2").order("name ASC, surname1 ASC, surname2 ASC")
    @authors
  end

  def self.find_all_authors_except(ids)
    @authors = Author.where("id not in (#{ids})").select("id, name, surname1, surname2").order("name ASC, surname1 ASC, surname2 ASC")
    @authors
  end

  def add_visit
    self.update_attribute(:num_visits, self.num_visits + 1)
  end

  private

    # Devuelve cierto si el campo email no es nulo
    def email_not_blank?
      return true unless self.email.blank?
      return false
    end

    # Funcion para limpiar código de una web
    def clean_http_web
      self.web = self.web.starts_with?("http://") ? self.web : ("http://" + self.web.gsub("https://", "")) unless self.web.blank?
    end

end