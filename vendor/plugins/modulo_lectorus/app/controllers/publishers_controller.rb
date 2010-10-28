class PublishersController < ApplicationController

  before_filter :admin_required
  before_filter :get_site, :only => [:create]
  before_filter :get_publisher, :only => [:edit, :update, :destroy]

  def index
    @publishers = Publisher.where(:site_id => session[:site_id]).order("name ASC")
    @publishers = @publishers.paginate :page => params[:page], :per_page => APP_CONFIG["medium_default_pagination"]
  end

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new(params[:publisher])
    @publisher.site_id = @site.id
    @publisher.lang = @site.value

    if @publisher.save
      redirect_to(publishers_path(:page => params[:page]), :notice => t("publisher.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if (@publisher.update_attributes(params[:publisher]))
      redirect_to(authors_path(:page => params[:page]), :notice => t("publisher.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @publisher.destroy
    redirect_to(authors_path(:page => params[:page]), :notice => t("publisher.destroyed"))
  end

  private

    def get_publisher
      begin
        @publisher = Publisher.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(publishers_path(:page => params[:page]), :error => t("publisher.not_exist"))
      end
    end
end