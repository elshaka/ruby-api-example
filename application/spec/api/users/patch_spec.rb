require 'spec_helper'

describe 'PATCH /api/users/:id' do
  let(:user) { create(:user) }

  context 'when logged in' do
    let(:user_auth_header) { login_as(user) }
    let(:new_password) { attributes_for(:user)[:password] }
    let(:another_password) { attributes_for(:user)[:password] }
    let(:another_user) { create(:user) }

    context 'and password confirmation matches' do
      let(:params) { {password: new_password, password_confirmation: new_password} }

      it 'should update password' do
        patch "/api/v1.0/users/#{user.id}", params, user_auth_header

        updated_password = Api::Models::User.find(id: user.id).password
        expect(updated_password).to eq new_password
      end

      it 'should not allow to update another user password' do
        patch "/api/v1.0/users/#{another_user.id}", params, user_auth_header

        updated_password = Api::Models::User.find(id: another_user.id).password
        expect(updated_password).to eq another_user.password
        expect(last_response.status).to eq 403
      end
    end

    context 'and password confirmation does not match' do
      let(:invalid_params) { {password: new_password, password_confirmation: another_password} }

      it 'should not update password' do

        patch "/api/v1.0/users/#{user.id}", invalid_params, user_auth_header

        updated_password = Api::Models::User.find(id: user.id).password
        expect(updated_password).to eq user.password
        expect(last_response.status).to eq 400
      end
    end
  end

  context 'when not logged in' do
    it 'should return 401 unauthorized' do
      patch "api/v1.0/users/#{user.id}", {password: "hunter123", password_confirmation: "hunter123"}

      expect(last_response.status).to eq 401
    end
  end
end
