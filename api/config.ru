require 'rack/cors'
require './config/application.rb'
require 'grape_logging'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :patch, :post, :delete]
  end
end

use Rack::Session::Cookie, :key => 'rack.session',
    :expire_after => 2592000,
    :secret => Sentinel::Config.application.session_secret_key,
    :old_secret => Sentinel::Config.application.session_secret_key

use GrapeLogging::Middleware::RequestLogger, { logger: Sentinel.logger }
run Sentinel::Api.new
