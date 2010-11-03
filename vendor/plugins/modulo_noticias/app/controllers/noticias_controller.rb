class NoticiasController < ApplicationController

  # Helper para controlar las columnas de ordenacion (por defecto name ASC)
  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_site, :only => [:create]
  before_filter :get_noticia, :only => [:edit, :update, :show, :destroy, :comment, :add_visit]
  after_filter :add_visit_to_noticia, :only => [:show]

  def index
    @noticias = Noticia.where("site_id = #{session[:site_id]}")
    @noticias = @noticias.order(sort_column + " " + sort_direction)
    @noticias = @noticias.paginate :page => params[:page], :per_page => APP_CONFIG["noticias_pagination"]
  end

  def order
    @noticias = Noticia.where("site_id = #{session[:site_id]}")
    @noticias = @noticias.order(sort_column + " " + sort_direction)
    @noticias = @noticias.paginate :page => params[:page], :per_page => APP_CONFIG["noticias_pagination"]
    render :action => :index
  end

  def list
    @noticias = Noticia.find_published
    @noticias = @noticias.paginate :page => params[:page], :per_page => APP_CONFIG["noticias_pagination"] unless @noticias.blank?
  end
  
  def new
    @noticia = Noticia.new
  end

  def create
    @noticia = Noticia.new(params[:noticia])
    @noticia.site_id = @site.id
    @noticia.lang = @site.value

    if @noticia.save
      redirect_to(noticias_path(:page => params[:page]), :notice => t("noticia.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def show
    # Sacamos los comentarios validos para el usuario en caso de que lo haya
    @comments = @noticia.comments_validos
  end

  def update
    if (@noticia.update_attributes(params[:noticia]))
      redirect_to(noticias_path(:page => params[:page]), :notice => t("noticia.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @noticia.destroy
    redirect_to(noticias_path(:page => params[:page]), :notice => t("noticia.destroyed"))
  end

  def comment
    @comment = Comment.new(params[:comment])
    @comment.user_id = session[:user_id]
    @noticia.add_comment @comment

    if @comment.save
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js {render :action => "comment_error"}
      end
    end
  end

  private

    # Conseguir la noticia seleccionada
    def get_noticia
      begin
        @noticia = Noticia.find(params[:id], :scope => session[:site_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(noticias_path(:page => params[:page]), :error => t("noticia.not_exist"))
      end
    end

    # Añadir una visita en la vista de la misma
    # Como es un after_filter necesito obtener el @noticia de nuevo
    def add_visit_to_noticia
      get_noticia
      @noticia.add_visit
    end

    def sort_column
      params[:sort] || "published_at"
    end

    def sort_direction
      params[:direction] || "desc"
    end
end