class EventsController < ApplicationController
  # Helper para controlar las columnas de ordenacion (por defecto name ASC)
  helper_method :sort_column, :sort_direction
  before_filter :admin_required
  before_filter :get_event, :only => [:edit, :update, :show, :destroy]
  after_filter :add_visit, :only => [:show]

  def index
    @events = Event.order(sort_column + " " + sort_direction)
    @events = @events.paginate :page => params[:page], :per_page => APP_CONFIG["events_pagination"]
  end

  def order
    @events = Event.order(sort_column + " " + sort_direction)
    @events = @events.paginate :page => params[:page], :per_page => APP_CONFIG["events_pagination"]
    render :action => :index
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])

    if @event.save
      redirect_to(events_path(:page => params[:page]), :notice => t("event.created"))
    else
      render :action => :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if (@event.update_attributes(params[:event]))
      redirect_to(events_path(:page => params[:page]), :notice => t("event.updated"))
    else
      render :action => :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to(events_path(:page => params[:page]), :notice => t("event.destroyed"))
  end

  private

    # Conseguir el evento seleccionado
    def get_event
      begin
        @noticia = Event.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to(events_path(:page => params[:page]), :error => t("event.not_exist"))
      end
    end

    # Añadir una visita en la vista de la misma
    def add_visit
      @event.update_attribute(:num_visits, @event.num_visits + 1)
    end

    def sort_column
      params[:sort] || "published_at"
    end

    def sort_direction
      params[:direction] || "desc"
    end
end