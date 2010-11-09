class PostsController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_blog, :only => [:index, :new, :create, :edit, :update, :show, :destroy, :comment]
  before_filter :get_post, :only => [:edit, :update, :show, :destroy, :comment]

  def index
    @posts = Post.find_published(@blog, sort_column + " " + sort_direction)
    @posts = @posts.paginate :page => params[:page], :per_page => APP_CONFIG["posts_pagination"]
  end

  def order
    @posts = Post.find_published(@blog, sort_column + " " + sort_direction)
    @posts = @posts.paginate :page => params[:page], :per_page => APP_CONFIG["posts_pagination"]
    render :action => :index
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    
    if @post.save
      redirect_to(blog_posts_path(@blog, :page => params[:page]), :notice => t("post.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def show
    # Sacamos los comentarios validos para el usuario en caso de que lo haya
    @comments = @post.comments_validos(session[:user_id])
  end

  def update
    if (@post.update_attributes(params[:post]))
      redirect_to(blog_posts_path(@blog, :page => params[:page]), :notice => t("post.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to(blog_posts_path(@blog, :page => params[:page]), :notice => t("post.destroyed"))
  end

  def comment
    @comment = Comment.new(params[:comment])
    @comment.user_id = session[:user_id]
    @post.add_comment @comment

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
    def get_blog
      begin
        @blog = Blog.find(params[:blog_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(blogs_path(:page => params[:page]), :error => t("post.not_exist"))
      end
    end

    def get_post
      begin
        puts @blog.id.to_yaml
        puts params[:id].to_yaml
        
        @post = Post.where(["blog_id = ? and cached_slug = ?", @blog.id, params[:id]]).first
      rescue ActiveRecord::RecordNotFound
        redirect_to(blog_posts_path(@blog, :page => params[:page]), :error => t("post.not_exist"))
      end
    end

    def sort_column
      params[:sort] || "title"
    end

    def sort_direction
      params[:direction] || "asc"
    end

end