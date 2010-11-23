class Category < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true, :approximate_ascii => true
  has_and_belongs_to_many :books, :order => "title ASC"
  acts_as_tree :order => "name ASC"
  
  validates :name, :presence => true

  before_validation :validate_parent

  # Valido si su categoría padre es padre a su vez porque no permito tercer nivel
  def validate_parent
    errors.add(I18n.t("category"), I18n.t("category.cant_third_level")) if Category.find(self.parent_id).parent != 0
  end

  def self.find_all_parent_categories
    self.where("parent_id = 0").order("name ASC")
  end

end
