require 'spec_helper'

describe 'POST /api/users/login' do
  let(:user) { create(:user) }

  context 'with valid credentials' do
    it 'should return an authentication token' do
      post 'api/v1.0/users/login', {email: user[:email], password: user[:password]}

      expect(response_body[:jwt]).not_to be_nil
    end
  end

  context 'with invalid credentials' do
    it 'should return 401 unauthorized' do
      post 'api/v1.0/users/login', {email: 'invalid', password: 'credentials'}

      expect(last_response.status).to eq 401
    end
  end
end