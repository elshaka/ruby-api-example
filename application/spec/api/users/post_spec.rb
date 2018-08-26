require 'spec_helper'

describe 'POST /api/users' do
  context 'with valid params' do
    let(:new_user_params) { FactoryGirl.attributes_for(:user) }
    let(:new_user) { Api::Entities::User.represent(Api::Models::User.new new_user_params) }

    before(:each) do
      post 'api/v1.0/users', user: new_user_params
    end

    it 'should create a new user' do
      last_user = Api::Entities::User.represent(Api::Models::User.last)

      expect(last_user.as_json).to eq new_user.as_json
    end

    it 'should return the created user in the response' do
      expect(response_body[:user]).to eq new_user.as_json
    end
  end

  context 'with invalid params' do
    let(:invalid_user_params) { FactoryGirl.attributes_for(:user, :empty)}
    let(:invalid_user) { Api::Entities::User.represent(Api::Models::User.new invalid_user_params) }

    before(:each) do
      post 'api/v1.0/users', user: invalid_user_params
    end

    it 'should not create a user' do
      last_user = Api::Entities::User.represent(Api::Models::User.last)

      expect(last_user.as_json).to_not eq invalid_user.as_json
    end

    it 'should return a 400 error' do
      expect(last_response.status).to eq 400
    end
  end
end
