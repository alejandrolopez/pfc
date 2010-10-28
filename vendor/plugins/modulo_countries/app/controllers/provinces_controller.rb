class ProvincesController < ApplicationController

  before_filter :get_country
  before_filter :get_province, :only => [:edit, :update, :destroy]
         
  def index
    @provinces = @country.provinces.paginate :page => params[:page], :per_page => 20
  end

  def new
    @province = Province.new
  end

  def create
    @province = Province.new(params[:province])
    @province.country_id = @country.id

    if @province.save
      redirect_to(country_provinces_path(@country, :page => params[:page]), :notice => t("province.created") )
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if (@province.update_attributes(params[:province]))
      redirect_to(country_provinces_path(@country, :page => params[:page]), :notice => t("province.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    begin
      @province.destroy
      redirect_to(country_provinces_path(@country, :page => params[:page]), :notice => t("province.destroyed"))
    rescue
      redirect_to(country_provinces_path(@country, :page => params[:page]), :error => t("province.not_destroyed"))
    end
  end

  private
  
    def get_country
      @country = Country.find(params[:country_id], :scope => session[:site_id])
    end

    def get_province
      @province = Province.find(params[:id], :scope => @country)
    end
end
