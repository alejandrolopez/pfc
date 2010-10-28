class Element < ActiveRecord::Base

  validates :controller, :presence => true
  validates :action, :presence => true
  validates :name, :presence => true

end