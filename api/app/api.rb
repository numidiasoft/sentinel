
module Sentinel
  class Api < Grape::API
    format :json
    formatter :json, Grape::Formatter::Roar

    desc "API root path"
    get "/" do
      { status: "Welcome to the sentinel API" }
    end

    mount StatusChecks
  end
end

