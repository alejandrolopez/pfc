class Country < ActiveRecord::Base

  validates :name, :presence => true
  validates :value, :presence => true

  has_many :provinces, :order => "name ASC", :dependent => :destroy
  has_many :authors, :order => "name ASC"
  
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  
end