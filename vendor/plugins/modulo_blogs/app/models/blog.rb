class Blog < ActiveRecord::Base

  validates :title, :presence => true
  validates :description, :presence => true

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true

  has_many :posts

end