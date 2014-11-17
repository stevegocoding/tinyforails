class UsersController < ApplicationController
  def new
    store_location params[:return_to]
    @user = User.new
  end
  
  def create
    @user = User.new params.require(:user).permit(:username, :email, :name, :password)
    if @user.save 
      # login_as @user
      puts 'SAVE USER SUCCESSFULLY'
      redirect_back_or_default root_url
    else
      render :new
    end
  end
 
end
