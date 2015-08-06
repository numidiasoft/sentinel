require 'rack/cors'
require './config/application.rb'
require 'grape_logging'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :patch, :post, :delete]
  end
end

use GrapeLogging::Middleware::RequestLogger, { logger: Sentinel.logger }
run Sentinel::Api.new
