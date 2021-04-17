require 'spec_helper'
require 'rails_helper'

describe Api::V1::UsersController, type: :request do

  describe 'show' do
    it 'should have required keys in response' do
      user = users(:one)
      get "/api/v1/users/#{user.id}"

      expect(response.content_type).to include("application/json")
    end
  end
end