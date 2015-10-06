#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../config/application'
require 'colorize'

module Sentinel
  module Scripts
    module Checker
      extend self
      def process
        Sentinel::HealthCheck.check_all(async: true)
      end
    end
  end
end

Sentinel::Scripts::Checker.process
