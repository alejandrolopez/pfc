class Critic < ActiveRecord::Base

  belongs_to :book
  belongs_to :user
  
  has_friendly_id :title, :use_slug => true, :approximate_ascii => true, :scope => :book

  # before_save :cut_description_to_summary

  # Voy a cortar a partir de la descripcion en el resumen
  def cut_description_to_summary
    self.summary = self.description
  end

  # Metodo para publicar una critica con la fecha actual
  def publish
    self.update_attribute(:published, true)
    self.update_attribute(:published_at, Time.now)
  end

end