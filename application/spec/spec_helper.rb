require 'rspec/core'
require 'rack/test'
ENV['RACK_ENV'] = 'test'
require './application/api'
require 'faker'
require 'factory_girl'
require 'sidekiq/testing'

# Load up all application files that we'll be testing in the suites
Dir['./application/models/**/*.rb'].sort.each     { |rb| require rb }

FactoryGirl.definition_file_paths = %w{./application/spec/factories}
FactoryGirl.find_definitions

# Factory Girl is expecting ActiveRecord
class Sequel::Model
  alias_method :save!, :save
end

class RSpecConstants
end

module RSpecHelpers
  include Rack::Test::Methods
  include Api::Auth::HelperMethods

  def login_as user
    token = issue_token user
    {'HTTP_AUTHORIZATION' => "Bearer #{token}"}
  end

  def app
    Api
  end

  def response_body
    JSON.parse(last_response.body, symbolize_names: true)
  end

  def get_scope opts = {}
    scope = Api.new
    scope.instance_variable_set(:@current_user, opts[:as_user])
    scope
  end
end

SEQUEL_DB = Api::SEQUEL_DB
# Clear old test data
SEQUEL_DB.tables.each do |t|
  # we don't want to clean the schema_migrations table
  SEQUEL_DB.from(t).truncate unless t == :schema_migrations || t.to_s.match(/^oauth_/)
end

Faker::Config.locale = 'en-US'

Sidekiq::Testing.fake!

Mail.defaults do
  delivery_method :test
end

RSpec.configure do |config|
  config.extend RSpecHelpers
  config.include RSpecHelpers
  config.include FactoryGirl::Syntax::Methods
  config.filter_run_excluding :slow
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.backtrace_exclusion_patterns << /\/.rvm\//

  config.before(:all) do
    Sidekiq::Worker.clear_all
    Mail::TestMailer.deliveries.clear
  end

  config.before(:each) do
    Sidekiq::Worker.clear_all
    Mail::TestMailer.deliveries.clear
  end

  config.around(:all) do |example|
    Sequel.transaction [SEQUEL_DB], rollback: :always do
      example.run
    end
  end

  config.around(:each) do |example|
    Sequel.transaction([SEQUEL_DB], rollback: :always, savepoint: true, auto_savepoint: true) do
      example.run
    end
  end
end
