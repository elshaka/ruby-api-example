require 'spec_helper'

describe 'POST /api/users' do
  context 'with valid params' do
    let(:new_user_params) { FactoryGirl.attributes_for(:user) }
    let(:expected_user_attrs) { [:first_name, :last_name, :email] }

    before(:each) do
      post 'api/v1.0/users', user: new_user_params
    end

    it 'should create a new user' do
      last_user = Api::Models::User.last

      expected_user_attrs.each do |attr|
        expect(last_user[attr]).to eq new_user_params[attr]
      end
    end

    it 'should return the created user in the response' do
      expected_user_attrs.each do |attr|
        expect(response_body[:user][attr]).to eq new_user_params[attr]
      end
    end
  end

  context 'with invalid params' do
    let(:invalid_user_params) { FactoryGirl.attributes_for(:user, :empty)}
    let(:user_count) { Api::Models::User.count }

    before(:each) do
      post 'api/v1.0/users', user: invalid_user_params
    end

    it 'should not create a user' do
      expect(Api::Models::User.count).to eq user_count
    end

    it 'should return a 400 error' do
      expect(last_response.status).to eq 400
    end
  end
end
