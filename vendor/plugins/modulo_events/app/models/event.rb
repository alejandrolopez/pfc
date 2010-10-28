class Event < ActiveRecord::Base

  validates :title, :presence => true
  validates :summary, :presence => true
  validates :description, :presence => true

  belongs_to :site
  before_save :published_or_not

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true, :scope => :site

  def validate
    if self.unpublished_at < self.published_at
      errors.add("published_at", I18n.t("event.published_at_more_less_than_unpublished_at"))
    end
  end

  # Validacion de si la noticia debe publicarse o no
  def published_or_not
    self.published = (self.published_at <= Time.now and self.unpublished_at >= Time.now) ? 1 : 0
  end

  # Recorremos todas las noticias y comprobamos su fecha (con guardar sirve para que se realice la validacion)
  def self.publish_events
    Event.where("published = 1").collect(&:save)
  end

end