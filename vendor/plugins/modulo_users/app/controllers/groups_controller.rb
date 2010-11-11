class GroupsController < ApplicationController

  # Helper para controlar las columnas de ordenacion (por defecto name ASC)
  helper_method :sort_column, :sort_direction
  before_filter :admin_required, :except => [:new, :create]
  before_filter :get_group, :only => [:show, :edit, :update, :destroy, :add_user, :add_user_to_group, :delete_from_group]

  # Listado de grupos
  def list
    @groups = Group.order(sort_column + " " + sort_direction)
    @groups = @groups.paginate :per_page => APP_CONFIG["default_pagination"], :page => params[:page]
  end

  # Listado ordenado de grupos
  def order
    @groups = Group.order(sort_column + " " + sort_direction)
    @groups = @groups.paginate :per_page => APP_CONFIG["default_pagination"], :page => params[:page]
    render :action => :index
  end

  # Pantalla de nuevo grupo
  def new
    @group = Group.new
  end

  # Accion de crear el grupo
  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to(list_groups_path(:page => params[:page]), :notice => t("group.created"))
    else
      render :action => :new
    end
  end

  # Pantalla de edit, obtengo el @group del filtro
  def edit
  end

  # Actualizar datos del grupo
  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = t("group.updated")
      redirect_to list_groups_path(:page => params[:page])
      return
    end

    render :action => :edit
  end

  # Mostrar datos del grupo
  def show
    @users = @group.users_del_grupo
  end

  # Eliminamos el grupo elegido
  def destroy
    begin
      if Group.size > 1
        @group.destroy
        redirect_to(list_groups_path(:page => params[:page]), :notice => t("group.destroyed"))
      else
        redirect_to(list_groups_path(:page => params[:page]), :notice => t("group.last_one"))
      end
    rescue
      redirect_to(list_groups_path(:page => params[:page]), :error => t("group.not_destroyed"))
    end
  end

  # Pantalla en la que aparecen los usuarios a añadir
  def add_user
    unless @group.users.blank?
      @users = User.all(:select => "id, login", :conditions => "id not in(#{@group.users_del_grupo.collect(&:id).join(",")})", :order => "login ASC")
    else
      @users = User.all(:select => "id, login", :order => "login ASC")
    end

    respond_to do |format|
      format.js
    end
  end

  # Ejecucion de añadir un usuario al grupo
  def add_user_to_group
    @user = User.find(params[:user_id])
    @group.add_to_group(@user)
    
    respond_to do |format|
      format.js
    end
  end

  # Borrar a un usuario del grupo
  def delete_from_group
    @user = User.find(params[:user_id], :select => "id")
    @group.delete_from_group(@user)

    respond_to do |format|
      format.js
    end
  end
  
  private 
  
    def get_group
      @group = Group.find(params[:id])
    end

    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "asc"
    end
end