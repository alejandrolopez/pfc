require 'spec_helper'
require 'group'
require 'user'

describe "Modelo user", :type => :model do
  before(:each) do
    @valid_attributes = {
      :login => "Login",
      :email => "alejandro.lopez@vorago.es",
      :password => "Password"
    }
  end
  
  it "deberia devolver error en creacion" do
    user = User.new
    user.should_not be_valid
  end

  it "deberia devolver acierto en creacion" do
    user = User.new(@valid_attributes)
    user.should be_valid
  end

  it "deberia devolver inactivo segun se crea" do
    user = User.new(@valid_attributes)
    user.should_not be_active
  end

  it "deberia devolver activo cuando se activa un usuario creado" do
    user = User.new(@valid_attributes)
    user.activate
    user.should be_active
  end

  it "admin deberia pertenecer al grupo administradores" do
    group = Group.where("name = 'administradores'").first
    user = User.where("login = 'admin'").first
    user.pertenece_al_grupo?(group).should be_true
  end

  it "un usuario de sistema pertenece a todos los grupos de sistema" do
    groups = Group.where("system = 1")
    users = User.where("system = 1")

    users.each do |u|
      groups.each do |g|
        u.pertenece_al_grupo?(g).should be_true
      end
    end
  end

end
