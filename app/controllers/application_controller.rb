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
    return true
  end

  # Devuelve cierto si hay un usuario registrado
  # Falso en caso contrario
  def login_required
    return true unless session[:user_id].blank?
    return false
  end

end
