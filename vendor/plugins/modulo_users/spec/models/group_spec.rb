require 'spec_helper'
require 'site'
require 'user'
require 'group'


describe "Modelo group", :type => :model do
  before(:each) do
    @valid_attributes = {
      :name => "Grupo"
      }
  end

  it "deberia devolver error en creacion" do
    group = Group.new
    group.should_not be_valid
  end

  it "deberia devolver acierto en creacion" do
    group = Group.new(@valid_attributes)
    group.should be_valid
  end

  it "que sea system debe tener anadidos a todos los usuarios system" do
    groups = Group.where("system = 1")
    users = User.where("system = 1")

    users.each do |u|
      groups.each do |g|
        u.pertenece_al_grupo?(g).should be_true
      end
    end
  end
end