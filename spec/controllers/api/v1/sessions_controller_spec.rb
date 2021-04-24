require 'rails_helper'

describe Api::V1::SessionsController, type: :request do
  describe 'login' do
    let(:id_token) {
      'eyJhbGciOiJIUzI1NiJ9.'\
      'eyJlbWFpbCI6InRlc3R1c2VyQG5vdGhpbmcuY29tIiwiZXhwIjoxNjE5MzQ4MjM5fQ.'\
      'zlEoGy1xUEN_cL64udAwlpvnr6EkhZa4Hw0E3X_VwFk'
    }

    subject(:user_login) { post '/api/v1/auth/login', params: { id_token: id_token } }

    context 'when id_token is valid' do
      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check).and_return({
          'email' => 'testuser@nothing.com'
        })
      end

      it 'successfully logs in' do
        user_login
        expect(response).to have_http_status(:success)
      end

      skip 'creates a new user' do
      end
    end

    context 'when id_token is invalid' do
      before do
        allow_any_instance_of(GoogleIDToken::Validator)
          .to receive(:check).and_raise(GoogleIDToken::ValidationError)
      end

      it 'fails to log in' do
        user_login
        expect(response).to have_http_status(:unauthorized)
      end

      skip 'does not create a new user' do
      end
    end
  end
end
