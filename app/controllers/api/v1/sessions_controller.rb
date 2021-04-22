class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def login
    validator = GoogleIDToken::Validator.new
    begin
      token = params[:id_token]
      aud = JWT.decode(token, nil, false)[0]['aud']
      payload = validator.check(token, aud)

      user = User.find_or_create_by(email: payload['email'])

      render json: {
        access_token: JsonWebTokenService.encode({ email: user.email }),
        user: user
      }, status: :ok

    rescue GoogleIDToken::ValidationError => e
      head :unauthorized
    end
  end
end
