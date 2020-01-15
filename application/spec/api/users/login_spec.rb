require 'spec_helper'

describe 'POST /api/users/login' do
  let(:user) { create(:user) }

  context 'with valid credentials' do
    it 'should return a valid authentication token' do
      post 'api/v1.0/users/login', {email: user[:email], password: user[:password]}
      get "api/v1.0/users/#{user.id}", nil, {'HTTP_AUTHORIZATION' => "Bearer #{response_body[:jwt]}"}

      expect(last_response.status).to eq 200
    end
  end

  context 'with invalid credentials' do
    it 'should return 401 unauthorized' do
      post 'api/v1.0/users/login', {email: 'invalid', password: 'credentials'}

      expect(last_response.status).to eq 401
    end
  end
end
