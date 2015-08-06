
module Sentinel
  class Api < Grape::API
    use Rack::Session::Cookie, :key => 'rack.session',
      :expire_after => 2592000,
      :secret => Sentinel::Config.application.session_secret_key,
      :old_secret => Sentinel::Config.application.session_secret_key

    format :json
    formatter :json, Grape::Formatter::Roar
    helpers do
      def logger
       Sentinel.logger
      end

      def session
        env['rack.session']
      end
    end

    desc "API root path"
    get "/" do
      { status: "Welcome to the sentinel API" }
    end

    mount AuthenticationApi
    mount StatusChecksApi
    mount StatusesApi
    mount UserApi
    mount MetricApi
  end
end

