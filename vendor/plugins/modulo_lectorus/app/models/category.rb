class Category < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  has_many :books, :order => "title ASC"
  
  validates :name, :presence => true

  def self.find_all_categories
    self.order("name ASC")
  end

end
