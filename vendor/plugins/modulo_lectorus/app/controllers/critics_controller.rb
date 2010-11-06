class CriticsController < ApplicationController

  before_filter :admin_required
  before_filter :get_site, :only => [:create]
  before_filter :get_book
  before_filter :get_critic, :only => [:edit, :update, :destroy, :show]
  after_filter :add_visit, :only => [:show]

  def index
    @critics = @book.critics
    @critics = @critics.paginate :page => params[:page], :per_page => APP_CONFIG["critics_pagination"]
  end

  def list
    @critics = @book.critics
    @critics = @critics.paginate :page => params[:page], :per_page => APP_CONFIG["critics_pagination"]
  end

  def show
    # Sacamos los comentarios validos para el usuario en caso de que lo haya
    # @comments = @critic.comments_validos(session[:user_id])
  end

  def new
    @critic = Critic.new
  end

  # El guardado de un libro se complementa en application.js con una llamada click al boton .save_book
  def create
    @critic = Critic.new(params[:critic])
    @critic.book_id = @book.id

    if @critic.save
      redirect_to(book_critics_path(@book, :page => params[:page]), :notice => t("critic.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  # El guardado de un libro se complementa en application.js con una llamada click al boton .save_book
  def update
    if (@critic.update_attributes(params[:critic]))
      redirect_to(book_critics_path(@book, :page => params[:page]), :notice => t("critic.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @critic.destroy
    redirect_to(book_critics_path(@book, :page => params[:page]), :notice => t("critic.destroyed"))
  end

  def write_your_critic
    @critic = Critic.new(params[:critic])
    @critic.book_id = @book.id

    if @critic.save
      respond_to do |format|
        format.js {render :action => "wroten_critic"}
      end
    else
      respond_to do |format|
        format.js {render :action => "wroten_critic_error"}
      end
    end
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

    def get_book
      begin
        @book = Book.find(params[:book_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to books_path(:page => params[:page], :error => t("book.dont_exist"))
      end
    end

    def get_critic
      begin
        @critic = @book.critics.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to critic_books_path(@book, :page => params[:page], :error => t("book.dont_exist"))
      end
    end

    # Antes de aumentar visita tengo que obtener el libro y la critica que estamos leyendo
    def add_visit
      get_book
      get_critic
      @critic.update_attribute(:num_visits, @critic.num_visits + 1)
    end

end