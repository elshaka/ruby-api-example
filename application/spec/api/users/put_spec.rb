require 'spec_helper'

describe 'PUT /users/:id' do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:update_params) { {first_name: 'Eleazar', last_name: 'Meza'} }

  context 'when logged in' do
    it 'should update current user' do
      put "api/v1.0/users/#{user1.id}", {user: update_params}, login_as(user1)

      updated_user = Api::Models::User.find id: user1.id
      update_params.each do |attr, updated_value|
        expect(attr => updated_user[attr]).to eq(attr => updated_value)
      end
    end

    it 'should forbid to update other users' do
      put "api/v1.0/users/#{user1.id}", {user: update_params}, login_as(user2)

      expect(last_response.status).to eq 403
    end
  end

  context 'when not logged in' do
    it 'should return 401 unauthorized' do
      put "api/v1.0/users/#{user1.id}", {user: update_params}

      expect(last_response.status).to eq 401
    end
  end
end
