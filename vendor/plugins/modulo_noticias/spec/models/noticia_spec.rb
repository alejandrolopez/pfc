require 'spec_helper'
require 'site'
require 'noticia'

describe "Modulo de noticia", :type => "model" do
  before(:each) do
    @valid_attributes = {
      :title => "Title",
      :summary => "Summary",
      :description => "Description",
      :published_at => Time.now,
      :unpublished_at => Time.now + 1.week
    }
  end

  it "deberia ser invalido hasta que tengamos titulo, resumen y descripcion" do
    noticia = Noticia.new
    noticia.should_not be_valid
    noticia.title ="Title"
    noticia.should_not be_valid
    noticia.summary = "Summary"
    noticia.should_not be_valid
    noticia.description = "Description"
    noticia.should be_valid
  end

  it "deberia ser valido" do
    noticia = Noticia.new(@valid_attributes)
    noticia.should be_valid
  end

  it "deberia ser publico si la fecha de publicacion es inferior o igual a hoy y la fecha de caducidad es superior a la fecha de hoy" do
    noticia = Noticia.new(@valid_attributes)
    noticia.published_at = Time.now
    noticia.unpublished_at = Time.now + 1.day
    noticia.published?.should be_true
  end

  it "no deberia ser publico si la fecha de publicacion y caducidad son inferior a hoy" do
    noticia = Noticia.new(@valid_attributes)
    noticia.published_at = Time.now - 2.day
    noticia.unpublished_at = Time.now - 1.day
    noticia.published?.should be_false
  end

  it "no deberia ser publico si la fecha de publicacion y caducidad son superior a hoy" do
    noticia = Noticia.new(@valid_attributes)
    noticia.published_at = Time.now + 1.day
    noticia.unpublished_at = Time.now + 2.day
    noticia.published?.should be_false
  end

  it "no deberia ser valido si la fecha de publicacion es superior a la fecha de caducidad" do
    noticia = Noticia.new(@valid_attributes)
    noticia.published_at = Time.now + 2.day
    noticia.unpublished_at = Time.now + 1.day
    noticia.should_not be_valid
  end
end