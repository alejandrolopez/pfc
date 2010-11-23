class CategoriesController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_category, :only => [:edit, :update, :destroy, :show]
  
  def list
    @categories = Category.where("parent_id = 0").order(sort_column + " " + sort_direction)
    @categories = @categories.paginate :page => params[:page], :per_page => APP_CONFIG["medium_default_pagination"]
  end

  def new
    @parent = Category.find(params[:parent_id]).id rescue 0
    @category = Category.new(:parent_id => @parent)
  end

  def create
    @category = Category.new(params[:category])

    if @category.save
      redirect_to(list_categories_path(:page => params[:page]), :notice => t("category.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if (@category.update_attributes(params[:category]))
      redirect_to(list_categories_path(:page => params[:page]), :notice => t("category.updated"))
    else
      render :action => :edit
    end
  end

  def show
    @books = @category.books
  end

  def destroy
    @category.destroy
    redirect_to(list_categories_path(:page => params[:page]), :notice => t("category.destroyed"))
  end

  private

    def get_category
      begin
        @category = Category.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(list_categories_path(:page => params[:page]), :error => t("category.not_exist"))
      end
    end

    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "asc"
    end

end