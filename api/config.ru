require "./config/application.rb"
require "grape_logging"

use GrapeLogging::Middleware::RequestLogger, { logger: Sentinel.logger }
run Sentinel::Api.new
