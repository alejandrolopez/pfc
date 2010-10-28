class LayoutsController < ApplicationController

  before_filter :admin_required
  before_filter :get_layout, :except => [:index, :new, :create]

  def index
    @layouts = Layout.all
  end

  def new
    @layout = Layout.new
  end

  def create
    @layout = Layout.new(params[:layout])

    if @layout.save
      redirect_to(layouts_path, :notice => t("layout.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @layout.update_attributes(params[:layout])
      redirect_to(layouts_path, :notice => t("layout.updated"))
    else
      render :action => "edit"
    end
  end

  # Establecer el layout por defecto
  def establish_base
    Layout.update_all("base = 0")
    @layout.update_attribute(:base, 1)

    redirect_to layouts_path, :notice => t("layout.updated")
  end

  # Administra los bloques del layout
  def administer_blocks
    @blocks = @layout.blocks
    @elements = Element.all
  end

  # Actualiza los bloques del layout
  def update_blocks
    begin
      @layout.blocks.each do |block|
        block.update_attribute(:element_id, params["block"]["#{block.id.to_s}"]["element_id"].to_s)
      end

      redirect_to(layouts_path, :notice => t("layout.updated"))
    rescue
      redirect_to(administer_blocks_layout_path(@layout), :error => t("layout.update_error"))
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.xml
  def destroy
    if @layout.destroy
      redirect_to(layouts_path, :notice => t("layout.destroyed"))
    else
      redirect_to(layouts_path, :error => t("layout.not_destroyed"))
    end
  end

  private

    def get_layout
      begin
        @layout = Layout.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(layouts_path, :error => t("layout.not_exist"))
      end
    end
end