require_relative '../config/application'
require 'colorize'

module Sentinel
  Sentinel::HealthCheck.check_all(async: true)
end
