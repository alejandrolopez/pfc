class Book < ActiveRecord::Base

  acts_as_commentable

  belongs_to :site
  has_and_belongs_to_many :authors

  has_friendly_id :title, :use_slug => true, :approximate_ascii => true

  validates :title, :presence => true
  validates :description, :presence => true

  def author_ids
    authors.collect(&:id).join(",")
  end

  def author_ids=(value)
    if value != self.authors.collect(&:author_id).join(",")
      self.authors.clear
      array_values = value
      array_values = value.split(",") if value.is_a?(String)
      array_values.each do |elto|
        begin
          self.authors << Author.find(elto)
        rescue
          nil
        end
      end
    end
  end

end