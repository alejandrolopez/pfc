class AuthorsController < ApplicationController

  before_filter :admin_required
  before_filter :get_site, :only => [:create]
  before_filter :get_countries, :only => [:new, :edit, :create, :update]
  before_filter :get_author, :only => [:show, :edit, :update, :destroy]

  def index
    @authors = Author.where(:site_id => session[:site_id]).order("name ASC")
    @authors = @authors.paginate :page => params[:page], :per_page => APP_CONFIG["medium_default_pagination"]
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(params[:author])
    @author.site_id = @site.id
    @author.lang = @site.value

    if @author.save
      redirect_to(authors_path(:page => params[:page]), :notice => t("author.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if (@author.update_attributes(params[:author]))
      redirect_to(authors_path(:page => params[:page]), :notice => t("author.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to(authors_path(:page => params[:page]), :notice => t("author.destroyed"))
  end

  private

    def get_author
      begin
        @author = Author.find(params[:id], :scope => session[:site_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(authors_path(:page => params[:page]), :error => t("author.not_exist"))
      end
    end

    def get_countries
      @countries = Country.where(:site_id => session[:site_id]).order("name")
    end

end