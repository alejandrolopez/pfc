class BooksController < ApplicationController

  before_filter :admin_required
  before_filter :get_site, :only => [:create]
  before_filter :get_all_authors, :only => [:new, :create, :edit, :update]
  before_filter :get_book, :only => [:edit, :update, :destroy, :show]
  after_filter :add_visit, :only => [:show]

  def index
    @books = Book.where("site_id = #{session[:site_id]}").order("title ASC")
    @books = @books.paginate :page => params[:page], :per_page => APP_CONFIG["books_pagination"]
  end

  def order
    @books = Book.where("site_id = #{session[:site_id]}")
    @books = @books.paginate :page => params[:page], :per_page => APP_CONFIG["books_pagination"]
    render :action => :index
  end

  def list
    @books = Book.find_published
    @books = @books.paginate :page => params[:page], :per_page => APP_CONFIG["books_pagination"] unless @books.blank?
  end

  def show
    # Sacamos los comentarios validos para el usuario en caso de que lo haya
    @comments = @book.comments_validos
    @critics = @book.critics_validas(5)
  end

  def new
    @book = Book.new
    session[:book_authors] = nil
  end

  # El guardado de un libro se complementa en application.js con una llamada click al boton .save_book
  def create
    @book = Book.new(params[:book])
    @book.site_id = @site.id

    if @book.save
      redirect_to(books_path(:page => params[:page]), :notice => t("book.created"))
    else
      render :action => :new
    end
  end

  def edit
    session[:book_authors] = nil
    session[:book_authors] = @book.authors.collect(&:id) rescue []
  end

  # El guardado de un libro se complementa en application.js con una llamada click al boton .save_book
  def update    
    if (@book.update_attributes(params[:book]))
      redirect_to(books_path(:page => params[:page]), :notice => t("book.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to(books_path(:page => params[:page]), :notice => t("book.destroyed"))
  end

  def comment
    @comment = Comment.new(params[:comment])
    @comment.user_id = session[:user_id]
    @book.add_comment @comment

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

  # Saco un listado de autores sin los que estan almacenados en session (cuando se crea de 0 o se guardó un libro sin autor)
  # o saco todos los autores ordenados por nombre
  def add_author
    @authors = Author.find_all_authors_except(session[:book_authors].join(",")) unless session[:book_authors].blank?
    @authors = Author.find_all_authors if @authors.blank?

    respond_to do |format|
      format.js
    end
  end

  # Añadimos a session al autor seleccionado
  def add_author_to_book
    @author = Author.find(params[:author_id])
    
    if !@author.blank? and !session[:book_authors].blank? and !(session[:book_authors].include?(@author.id))
      session[:book_authors] << @author.id
    end

    respond_to do |format|
      format.js
    end
  end

  # Eliminamos de la session al autor seleccionado
  def delete_author_from_book
    @author = Author.find(params[:author_id])
    session[:book_authors].delete @author.id unless @author.blank?

    respond_to do |format|
      format.js
    end
  end

  private

    def get_all_authors
      @authors = Author.find_all_authors
    end
  
    def get_book
      begin
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to books_path(:page => params[:page], :error => t("book.dont_exist"))
      end
    end

    def add_visit
      get_book
      @book.update_attribute(:num_visits, @book.num_visits + 1)
    end
end