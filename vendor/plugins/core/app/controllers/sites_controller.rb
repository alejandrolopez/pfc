class SitesController < ApplicationController

  before_filter :admin_required
  before_filter :get_site, :only => [:show, :edit, :update, :destroy]

  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])

    if @site.save
      redirect_to(@site, :notice => t("site.created"))
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @site.update_attributes(params[:site])
      redirect_to(@site, :notice => t("site.updated"))
    else
      render :action => "edit"
    end
  end

  def destroy
    if Site.count > 1
      begin
        @site.destroy

        redirect_to(sites_path, :notice => t("site.destroyed"))
      rescue
        redirect_to(sites_path, :error => t("site.not_destroyed"))
      end
    else
      redirect_to(sites_path, :notice => t("site.last_one"))
    end
  end
end