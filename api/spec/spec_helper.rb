require 'rspec'
require "rack/test"
require "factory_girl"
require 'database_cleaner'
require 'vcr'
require "grape"

ENV['RACK_ENV'] = "test"
require_relative '../config/application.rb'
Dir.glob("./spec/support/*.rb").each { |file| require file }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

# require all factories
Dir.glob('./spec/factories/*.rb').each do |file|
  require file
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

def app
  Sentinel::Api.new
end

def login(user)
  env 'rack.session', { user_id: user.id.to_s }
end

