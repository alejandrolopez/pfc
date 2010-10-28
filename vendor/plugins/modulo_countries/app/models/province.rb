class Province < ActiveRecord::Base

  validates :name, :presence => true
  belongs_to :country
  
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, :scope => :country
  
end