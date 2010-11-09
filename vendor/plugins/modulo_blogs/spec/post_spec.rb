require 'spec_helper'
require 'blog'
require 'post'

describe "Modelo post", :type => :model do
  before(:each) do
    @valid_attributes = {
      :title =>"Title",
      :summary => "Summary",
      :description => "Description",
      :unpublished_at => Time.now + 1.day
      }
  end
  it ""
end