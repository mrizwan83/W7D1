class ApplicationController < ActionController::Base

  # skip_before_action :verify_authenticity_token

  helper_method :current_user, :logged_in?
  private

  def require_no_user!
    redirect_to cats_url if current_user
  end

  def current_user
    return nil unless session[:session_token]
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

  def require_logged_out
    redirect_to users_url if logged_in?
  end

  def logged_in?
    !!current_user
  end

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout_user!
    current_user.reset_session_token! if logged_in? #database side 
    session[:session_token] = nil #browser side as cookies
    @current_user = nil
  end

  def require_user!
    redirect_to new_session_url if current_user.nil?
  end
end
