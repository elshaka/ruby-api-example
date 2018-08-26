require File.expand_path '../application/api.rb', __FILE__
# Grape Batch needs to be added as a Rack Middleware in order to intercept
# batch requests
use Grape::Batch::Base

use Rack::Static,
  urls: ["/docs"],
  root: 'application/public/api',
  index: 'index.html'

run Api
