module Request
  module JsonHelpers
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  module AuthHelper
    def sign_in_as(user)
      allow(JsonWebTokenService).to receive(:decode).and_return(email: user.email)
    end
  end
end