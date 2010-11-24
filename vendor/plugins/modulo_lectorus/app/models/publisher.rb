class Publisher < ActiveRecord::Base

  has_and_belongs_to_many :books, :order => "title ASC", :uniq => true
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true

  validates :name, :presence => true
  validates :description, :presence => true

  def self.find_all_publishers
    @publishers = self.select("id, name").order("name ASC")
    @publishers
  end

  def self.find_all_publishers_except(ids)
    @publishers = Publisher.where("id not in (#{ids})").select("id, name").order("name ASC")
    @publishers
  end

  def add_visit
    self.update_attribute(:num_visits, self.num_visits + 1)
  end

end