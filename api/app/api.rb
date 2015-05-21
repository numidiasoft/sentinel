
module Sentinel
  class Api < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar
    helpers do
      def logger
       Sentinel.logger
      end
    end

    desc "API root path"
    get "/" do
      { status: "Welcome to the sentinel API" }
    end

    mount StatusChecks
  end
end

