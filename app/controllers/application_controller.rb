class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def login_required
    unless current_user
      flash[:notice] = 'Access denied. Login required.'
      redirect_to root_path
    end
  end
end
