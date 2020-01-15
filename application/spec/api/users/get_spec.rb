require 'spec_helper'

describe 'GET /api/users' do
  before :all do
    @u1 = create :user
    @u2 = create :user
  end

  it 'should pull all users' do
    get "api/v1.0/users"
    body = response_body
    emails = body[:users].map{ |x| x[:email] }
    expect(emails).to include @u1.email
    expect(emails).to include @u2.email
  end

  it 'should retrieve the current user' do
    auth_header = login_as @u1
    get "api/v1.0/users/#{@u1.id}", auth_header
    retrieved_user = response_body[:user]

    [:first_name, :last_name, :email].each do |attr|
      expect(retrieved_user[attr]).to eq @u1[attr]
    end
  end
end
