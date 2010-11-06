class Critic < ActiveRecord::Base

  belongs_to :book
  has_friendly_id :title, :use_slug => true, :approximate_ascii => true, :scope => :book

end