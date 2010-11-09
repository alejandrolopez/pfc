class UsersController < ApplicationController

  # Helper para controlar las columnas de ordenacion (por defecto name ASC)
  helper_method :sort_column, :sort_direction
  before_filter :admin_required, :except => [:new, :create]
  before_filter :get_user, :only => [:show, :edit, :update, :destroy, :activate]

  def index
    @users = User.order(sort_column + " " + sort_direction)
    @users = @users.paginate(:per_page => APP_CONFIG["default_pagination"], :page => params[:page])
  end
  
  def order
    @users = User.order(sort_column + " " + sort_direction)
    @users = @users.paginate :per_page => APP_CONFIG["default_pagination"], :page => params[:page]
    render :action => :index
  end
  
  def show
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])

    if @user.save
      # Se envia un correo al usuario para activar sus datos
      UserMailer.registration_confirmation(@user, request.host_with_port).deliver
      redirect_to(users_path(:page => params[:page]), :notice => t("user.created"))
    else
      render :action => :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to(users_path(:page => params[:page]), :notice => t("user.updated"))
    else
      render :action => :edit
    end  
  end
  
  def destroy
    begin
      if User.count > 1
        @user.destroy
        redirect_to(users_path(:page => params[:page]), :notice => t("user.destroyed"))
      else
        redirect_to(users_path(:page => params[:page]), :notice => t("user.last_one"))
      end
    rescue
      redirect_to(users_path(:page => params[:page]), :error => t("user.not_destroyed"))
    end
  end

  def activate
    @user = User.where(["login = ? and activation_code = ?", params[:id], params[:activation_code]]).first

    unless @user.blank?
      @user.activate
      redirect_to(users_path, :notice => t("user.activated"))
    else
      redirect_to(users_path, :error => t("user.not_activated"))
    end
  end

  def remember_password
    @user = User.where(["email = ?", params[:email]]).first

    unless @user.blank?
      @user.generar_remember_token
      # Se envia un correo al usuario para activar sus datos
      UserMailer.remember_password(@user, request.host_with_port).deliver
      redirect_to(users_path, :notice => t("user.mail_sent_to_new_password"))
    else
      redirect_to(forget_password_user_path, :error => t("user.dont_exist_mail"))
    end
  end

  def save_new_password
    @user = User.where(["login = ? and remember_token = ?", params[:id], params[:token]]).first

    if request.post?
      if @user and @user.remember_token_expires_at >= Time.now
        if @user.update_attributes(params[:user])
          redirect_to(users_path, :notice => t("user.password_modified"))
        else
          render :action => :save_new_password
        end
      else
        redirect_to(users_path, :error => t("user.password_not_modified"))
      end
    end
  end
  
  private
  
    def get_user
      @user = User.find(params[:id])
    end

    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "asc"
    end
end
