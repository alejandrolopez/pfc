class Blog < ActiveRecord::Base

  validates :title, :presence => true
  validates :description, :presence => true

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true, :scope => :site

  belongs_to :site
  has_many :posts

end