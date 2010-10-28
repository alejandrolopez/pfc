class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  # Devuelve true si el usuario existe y además pertenece al grupo de administradores
  # Falso en caso contrario
  def admin_required
    session[:site_id] = 1
    return true
  end

  # Devuelve cierto si hay un usuario registrado
  # Falso en caso contrario
  def login_required
    return true unless session[:user_id].blank?
    return false
  end

  # Devuelve el site en el que nos encontramos
  def get_site
    @site = Site.find(session[:site_id])
  end

end
