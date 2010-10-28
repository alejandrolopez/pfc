class BooksController < ApplicationController

  before_filter :admin_required
  before_filter :get_site, :only => [:create]
  before_filter :get_all_authors, :only => [:new, :create, :edit, :update]
  before_filter :get_book, :only => [:edit, :update, :destroy, :show]
  after_filter :add_visit, :only => [:show]

  def index
    @books = Book.where("site_id = #{session[:site_id]}")
    @books = @books.paginate :page => params[:page], :per_page => APP_CONFIG["Books_pagination"]
  end

  def order
    @books = Book.where("site_id = #{session[:site_id]}")
    @books = @books.paginate :page => params[:page], :per_page => APP_CONFIG["Books_pagination"]
    render :action => :index
  end

  def list
    @books = Book.find_published
    @books = @books.paginate :page => params[:page], :per_page => APP_CONFIG["Books_pagination"] unless @books.blank?
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(params[:book])
    @book.site_id = @site.id

    if @book.save
      redirect_to(books_path(:page => params[:page]), :notice => t("Book.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def show
    # Sacamos los comentarios validos para el usuario en caso de que lo haya
    @comments = @book.comments_validos(session[:user_id])
  end

  def update
    if (@book.update_attributes(params[:book]))
      redirect_to(books_path(:page => params[:page]), :notice => t("book.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @Book.destroy
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

  private

    def get_all_authors
      @authors = Author.find_all_authors
    end
  
    def get_book
      begin
        @book = Book.find(params[:id])
      rescue ActiveRecordNotFound
        redirect_to books_path(:page => params[:page], :error => t("book.dont_exist"))
      end
    end

    def add_visit
      @book.update_attribute(:num_visits, @book.num_visits + 1)
    end
end