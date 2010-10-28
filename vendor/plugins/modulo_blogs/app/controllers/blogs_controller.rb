class BlogsController < ApplicationController

  # Helper para controlar las columnas de ordenacion (por defecto name ASC)
  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_site, :only => [:create]
  before_filter :get_blog, :only => [:edit, :update, :show, :destroy]

  def index
    @blogs = Blog.where("site_id = #{session[:site_id]}")
    @blogs = @blogs.order(sort_column + " " + sort_direction)
    @blogs = @blogs.paginate :page => params[:page], :per_page => APP_CONFIG["blogs_pagination"]
  end

  def order
    @blogs = Blog.where("site_id = #{session[:site_id]}")
    @blogs = @blogs.order(sort_column + " " + sort_direction)
    @blogs = @blogs.paginate :page => params[:page], :per_page => APP_CONFIG["blogs_pagination"]
    render :action => :index
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(params[:blog])
    @blog.site_id = @site.id
    @blog.lang = @site.value

    if @blog.save
      redirect_to(blogs_path(:page => params[:page]), :notice => t("blog.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if (@blog.update_attributes(params[:blog]))
      redirect_to(blogs_path(:page => params[:page]), :notice => t("blog.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @blog.destroy
    redirect_to(blogs_path(:page => params[:page]), :notice => t("blog.destroyed"))
  end

  private

    # Conseguir la noticia seleccionada
    def get_blog
      begin
        @blog = Blog.find(params[:id], :scope => session[:site_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(blogs_path(:page => params[:page]), :error => t("blog.not_exist"))
      end
    end

    def sort_column
      params[:sort] || "title"
    end

    def sort_direction
      params[:direction] || "asc"
    end
  
end