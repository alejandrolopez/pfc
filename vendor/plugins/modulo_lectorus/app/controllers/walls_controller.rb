class WallsController < ApplicationController

  # Helper para controlar las columnas de ordenacion (por defecto name ASC)
  before_filter :admin_required
  before_filter :get_wall, :only => [:index]
  # after_filter :add_visit, :only => [:index]

  def index
    @entries = @wall.entries.limit(15)
  end

  private

    def add_visit
      get_wall
      @wall.add_visit
    end

    def get_user
      begin
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        redirect_to("/", :error => t("user.not_exist"))
      end
    end

    def get_wall
      get_user
      @wall = @user.wall
    end

end