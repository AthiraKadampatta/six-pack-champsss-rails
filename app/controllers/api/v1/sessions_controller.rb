class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  api :POST, '/v1/auth/login', 'Create session and user for login'
  param :id_token, String, description: 'id_token returned by Google auth api', required: true
  param :name, String, description: 'name of the user'
  param :image, String, description: 'profile image url provided by google'
  def login
    begin
      payload = GoogleValidatorService.new(params[:id_token]).call
      return head :unauthorized unless payload

      user = fetch_user_by_email(payload['email'], params)

      render json: {
        access_token: JsonWebTokenService.encode({ email: user.email }),
        user: user
      }, status: :ok

    rescue StandardError => e
      head :unauthorized
    end
  end

  private

  def fetch_user_by_email(email, params)
    User.find_or_initialize_by(email: email).tap do |u|
      if u.new_record?
        u.name = params[:name]
        u.image_url = params[:image]
        u.save!
      end
    end
  end
end
