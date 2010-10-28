class LoginController < ApplicationController

  def index
    if request.post?
      session[:user_id] = User.authenticate(params[:login][:login], params[:login][:password]).id rescue nil

      if session[:user_id].blank?
        flash[:error] = t("user.login_or_password_bad")
      else
        redirect_to "/"
      end
    else
      unless session[:user_id].blank?
        flash[:notice] = t("user.you_re_logged")
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to(login_index_path, :notice => t("user.logout_success"))
  end

end