class Block < ActiveRecord::Base

  belongs_to :layout
  belongs_to :element
  
end