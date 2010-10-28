class UserMailer < ActionMailer::Base
  default :from => "alelop3z@gmail.com"

  def registration_confirmation(user, host)
    @user = user
    @host = host
    
    mail(:to => user.email, :subject => "Registered")
  end

  def remember_password(user, host)
    @user = user
    @host = host

    mail(:to => user.email, :subject => "Save a new password")
  end
end
