class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset] [:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
    end
    
   #Same message and redirect email whether or not email address is in system
    flash[:info] = "Email sent with password reset instructions"
    redirect_to root_url
  end

  def edit
  end
end
