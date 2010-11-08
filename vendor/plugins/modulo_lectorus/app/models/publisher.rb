class Publisher < ActiveRecord::Base

  has_many :books, :order => "title ASC"

  def self.find_all_publishers
    @publishers = self.select("id, name").order("name ASC")
    @publishers
  end

  def self.find_all_publishers_except(ids)
    @publishers = Publisher.where("id not in (#{ids})").select("id, name").order("name ASC")
    @publishers
  end

end