class SessionsController < ApplicationController
  def new
    store_location params[:return_to]
  end
  
  def create
    # Get the login name from parameters
    login = login_params[:login]
    # Query the user from database based on the login name is e-mail or username
    @user = if login.include?('@')
              User.where('lower(email) = lower(?)', login).first
            else
              User.where('lower(username) = lower(?)', login).first
            end 
    if @user && @user.authenticate(login_params[:password])
      login_as @user
      remember_me
      redirect_back_or_default root_url
    else
      flash.now[:warning] = 'Incorrect user name or password'
      render 'new'
    end
  end
  
  def destroy 
    logout
    redirect_to root_url 
  end
  
  private 

  def login_params
    params.require(:user).permit(:login, :password)
  end
end
