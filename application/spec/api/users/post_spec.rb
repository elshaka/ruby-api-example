require 'spec_helper'

describe 'POST /api/users' do
  context 'with valid params' do
    let(:new_user_params) { attributes_for(:user) }
    let(:expected_user_attrs) { [:first_name, :last_name, :email] }
    let(:last_user) { Api::Models::User.last }

    before(:each) do
      post 'api/v1.0/users', user: new_user_params
    end

    it 'should create a new user' do
      expected_user_attrs.each do |attr|
        expect(last_user[attr]).to eq new_user_params[attr]
      end
    end

    context 'the response' do
      it 'should return the created user' do
        expected_user_attrs.each do |attr|
          expect(attr => response_body[:user][attr]).to eq(attr => new_user_params[attr])
        end
      end

      it 'should expose the user id' do
        expect(response_body[:user][:id]).to eq last_user.id
      end

      it 'should not expose the user password' do
        expect(response_body[:user][:password]).to be_nil
      end
    end
  end

  context 'with invalid params' do
    let(:invalid_user_params) { attributes_for(:user, :empty) }
    let!(:user_count) { Api::Models::User.count }

    before(:each) do
      post 'api/v1.0/users', user: invalid_user_params
    end

    it 'should not create a user' do
      expect(Api::Models::User.count).to eq user_count
    end

    context 'the response' do
      it 'should have a 400 status' do
        expect(last_response.status).to eq 400
      end
    end
  end
end
