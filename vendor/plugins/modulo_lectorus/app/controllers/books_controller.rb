class BooksController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_all_authors, :only => [:new, :create, :edit, :update]
  before_filter :get_all_publishers, :only => [:new, :create, :edit, :update]
  before_filter :get_all_categories, :only => [:new, :create, :edit, :update]
  # before_filter :get_category, :only => [:new, :create, :edit, :update, :destroy, :show, :comment]
  before_filter :get_book, :only => [:edit, :update, :destroy, :show, :comment]
  after_filter :add_visit, :only => [:show]

  def list
    @books = Book.order(sort_column + " " + sort_direction)
    @books = @books.paginate :page => params[:page], :per_page => APP_CONFIG["books_pagination"]
  end

  def index
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
    session[:book_authors] = []
    session[:book_publishers] = []
  end

  # El guardado de un libro se complementa en application.js con una llamada click al boton .save_book
  def create
    @book = Book.new(params[:book])

    if @book.save
      redirect_to(list_books_path(:page => params[:page]), :notice => t("book.created"))
    else
      render :action => :new
    end
  end

  def edit
    session[:book_authors] = []
    session[:book_publishers] = []
    session[:book_authors] = @book.authors.collect(&:id) rescue []
    session[:book_publishers] = @book.publishers.collect(&:id) rescue []
  end

  # El guardado de un libro se complementa en application.js con una llamada click al boton .save_book
  def update    
    if (@book.update_attributes(params[:book]))
      redirect_to(list_books_path(:page => params[:page]), :notice => t("book.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to(list_books_path(:page => params[:page]), :notice => t("book.destroyed"))
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
    
    if !@author.blank? and !session[:book_authors].include?(@author.id)
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

  # Saco un listado deeditoriales sin los que estan almacenados en session (cuando se crea de 0 o se guardó un libro sin editorial)
  # o saco todas las editoriales ordenadas por nombre
  def add_publisher
    @publishers = Publisher.find_all_publishers_except(session[:book_publishers].join(",")) unless session[:book_publishers].blank?
    @publishers = Publisher.find_all_publishers if @publishers.blank?

    respond_to do |format|
      format.js
    end
  end

  # Añadimos a session la editorial seleccionada
  def add_publisher_to_book
    @publisher = Publisher.find(params[:publisher_id])

    if !@publisher.blank? and !session[:book_publishers].include?(@publisher.id)
      session[:book_publishers] << @publisher.id
    end

    respond_to do |format|
      format.js
    end
  end

  # Eliminamos de la session la editorial seleccionada
  def delete_publisher_from_book
    @publisher = Publisher.find(params[:publisher_id])
    session[:book_publishers].delete @publisher.id unless @publisher.blank?

    respond_to do |format|
      format.js
    end
  end

  private

    def get_all_authors
      @authors = Author.find_all_authors
    end

    def get_all_publishers
      @publishers = Publisher.find_all_publishers
    end

    def get_all_categories
      @categories = Category.find_all_categories
    end

    def get_book
      begin
        @book = Book.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to list_books_path(:page => params[:page], :error => t("book.dont_exist"))
      end
    end

    def get_category
      begin
        @category = Category.find(params[:category_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to list_categories_path(:page => params[:page], :error => t("category.dont_exist"))
      end
    end

    def add_visit
      get_book
      @book.update_attribute(:num_visits, @book.num_visits + 1)
    end

    def sort_column
      params[:sort] || "title"
    end

    def sort_direction
      params[:direction] || "desc"
    end
end