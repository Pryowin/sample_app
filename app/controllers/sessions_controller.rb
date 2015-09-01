class SessionsController < ApplicationController
  def new
  end
  
  def create   
    user = User.find_by(email: params[:session][:email].downcase)
    if (user && user.authenticate(params[:session][:password]))
      #Log the user in
    else
      # Create an error message
      flash.now[:danger] = "Invalid email or password"
      render 'new'  
    end  
  end
  
  def destroy
  end
  
end