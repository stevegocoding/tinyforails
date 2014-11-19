class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :signed_in?, :current_user
  
  def signed_in?
    !!current_user
  end
  
  def store_location(path)
    session[:return_to] = path
  end
  
  def redirect_back_or_default(default)
    redirect_to(session.delete(:return_to) || default)
  end
  
  def login_as(user)
    session[:user_id] = user.id
    @current_user = user 
  end
 
  def current_user
    @current_user ||= login_from_session || login_from_cookies unless defined?(@current_user)
    @current_user
  end
  
  def login_from_session
    if session[:user_id].present?
      begin
        User.find session[:user_id]
      rescue
        session[:user_id] = nil
      end
    end
  end
  
  def login_from_cookies
    if cookies[:remember_token].present?
      if user = User.find_by_remember_token(cookies[:remember_token])
        session[:user_id] = user.id
        user
      else 
        forget_me
        nil
      end
    end
  end
  
  def remember_me
    cookies[:remember_token] = {
      value: current_user.remember_token,
      expires: 2.weeks.from_now,
      httponly: true
    }
  end
  
  def forget_me
    cookies.delete(:remember_token)
  end
  
  def logout
    session.delete(:user_id)
    @current_user = nil 
    forget_me
  end
  
end
