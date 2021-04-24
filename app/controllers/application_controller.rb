class ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_accessor :current_user

  def authenticate_user!
    head :unauthorized unless user_email_in_token?
    fetch_current_user
  rescue JWT::VerificationError, JWT::DecodeError
    head :unauthorized
  end

  private

  def fetch_current_user
    @current_user = User.find_by(email: auth_token[:email])
  end

  def http_token
    @http_token ||= if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  def auth_token
    @auth_token ||= JsonWebTokenService.decode(http_token)
  end

  def user_email_in_token?
    http_token && auth_token && auth_token[:email]
  end
end
