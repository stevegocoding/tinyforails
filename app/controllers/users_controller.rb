class UsersController < ApplicationController
  def new
    store_location params[:return_to]
    @user = User.new
  end
end
