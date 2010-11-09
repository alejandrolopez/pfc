class CountriesController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_country, :only => [:edit, :update, :destroy]

  def index
    @countries = Country.order(sort_column + " " + sort_direction)
    @countries = @countries.paginate :page => params[:page], :per_page => 50
  end

  def new
    @country = Country.new
  end

  def create
    @country = Country.new(params[:country])
    @country.site_id = session[:site_id]

    if @country.save
      redirect_to(countries_path(:page => params[:page]), :notice => t("country.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if (@country.update_attributes(params[:country]))
      redirect_to(countries_path(:page => params[:page]), :notice => t("country.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @country.destroy
    redirect_to(countries_path(:page => params[:page]), :notice => t("country.destroyed"))
  end
  
  private 

    def get_country
      @country = Country.find(params[:id])
    end

    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "ASC"
    end
end
