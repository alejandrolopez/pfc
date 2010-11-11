class AuthorsController < ApplicationController

  # Helper para controlar las columnas de ordenacion (por defecto name ASC)
  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_countries, :only => [:new, :edit, :create, :update]
  before_filter :get_author, :only => [:show, :edit, :update, :destroy]

  def list
    @authors = Author.order(sort_column + " " + sort_direction)
    @authors = @authors.paginate :page => params[:page], :per_page => APP_CONFIG["medium_default_pagination"]
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(params[:author])
    
    if @author.save
      redirect_to(list_authors_path(:page => params[:page]), :notice => t("author.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if (@author.update_attributes(params[:author]))
      redirect_to(list_authors_path(:page => params[:page]), :notice => t("author.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to(list_authors_path(:page => params[:page]), :notice => t("author.destroyed"))
  end

  private

    def get_author
      begin
        @author = Author.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(list_authors_path(:page => params[:page]), :error => t("author.not_exist"))
      end
    end

    def get_countries
      @countries = Country.order("name ASC")
    end

    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "ASC"
    end

end