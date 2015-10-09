#!/usr/bin/env ruby
require 'pry'
require 'bundler'
root = File.expand_path '..', __dir__

ENV['RBENV_DIR'] = root
ENV['BUNDLE_GEMFILE'] = root + '/Gemfile'
ENV['RACK_ENV'] = ARGV[0] || 'development'

Bundler.setup
require_relative '../config/application'

Sentinel::User.new(email: "tarik@sleekapp.io", password: "aaaaaa", last_name: "tarik",
                first_name: "tarik", domain: "sleek").save unless Sentinel::User.where(email: "tarik@sleekapp.io").exists?

Sentinel::Check.new(name: "Sleek site", url: "http://sleekapp.io",
          type: "auto", protocol: "http", expected_response:"none",
          description: "Sleek app", verb: "GET", params: nil,
          status: "green", visibility: "public", user_id: Sentinel::User.last.id).save unless Sentinel::Check.where(url: "http://sleekapp.io").exists?

Sentinel::Influxdb::Base.connection.create_database("sentinel")
