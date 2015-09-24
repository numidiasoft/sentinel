require "active_support/inflector"
require "active_support"
require "sneakers"

module Sentinel
  ENV["RACK_ENV"] ||= "development"
  api_env = ENV["RACK_ENV"]

  def self.autoload_dir dir
    Dir.glob("#{dir}/*.rb").each do |file_name|
      _module = File.basename(file_name, '.rb').camelize.to_sym
      autoload _module, file_name
    end
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
    @logger.formatter = ::Sentinel::JsonFormatter.new unless @logger.formatter
    @logger
  end

  class Application

    def self.root_path
      @root = File.expand_path(File.join(__dir__, '/..'))
    end

    def initialize
      %w( mongoid roar/json roar/json/hal grape grape-roar kaminari kaminari/grape ).each do |lib|
        require lib
      end
      load_libs
      configuration = Sentinel::Configuration.load
      Sneakers.configure  :heartbeat => 2,
        :amqp => configuration.rabbitmq_url,
        :vhost => configuration.rabbitmq_url.split("/").last,
        :exchange_type => :topic,
        :prefetch => 10,
        :ack => true,
        :durable => true,
        :workers => 1,
        :share_threads => true
    end

    def load_libs
      Sentinel.autoload_dir File.expand_path File.join("app")
      Sentinel.autoload_dir File.expand_path File.join("app", "apis")
      Sentinel.autoload_dir File.expand_path File.join("app", "apis", "admin")
      Sentinel.autoload_dir File.expand_path File.join("app", "models")
      Sentinel.autoload_dir File.expand_path File.join("app", "presenters")
      Sentinel.autoload_dir File.expand_path File.join("lib")
      Sentinel.autoload_dir File.expand_path File.join("lib", "healthcheck")
      Sentinel.autoload_dir File.expand_path File.join("lib", "logger")
      Sentinel.autoload_dir File.expand_path File.join("lib", "middleware")
      Sentinel.autoload_dir File.expand_path File.join("lib", "middleware")
      Sentinel::Configuration.init
    end

  end

  module Configuration
    def self.init
      ::Mongoid.load!("config/application.yml", ENV['RACK_ENV'])
    end

    def self.load
      Hashie::Mash.load("config/application.yml")[ENV["RACK_ENV"]]
    end
  end
end

Sentinel::Application.new
