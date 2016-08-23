class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, prepend: true

  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  before_action :authenticate_user_from_token!
  before_action :authenticate_user!

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = ENV['ALLOWED_CROSS_ORIGINS']
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = ENV['ALLOWED_CROSS_ORIGINS']
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  private
  def authenticate_user_from_token!
      authenticate_with_http_token do |token, options|
          user_email = options[:email].presence
          user = user_email && User.find_by_email(user_email)

          if user && Devise.secure_compare(user.authentication_token, token)
              sign_in user, store: false
          end
      end
  end
end
