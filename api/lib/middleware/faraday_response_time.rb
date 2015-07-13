module Sentinel
  class FaradayResponseTime < Faraday::Middleware

    Faraday::Request.register_middleware :response_time => self

    def call(env)
      started_at = Time.now
      app        = @app.call(env)
      ended_at   = Time.now
      app.env[:duration] = (ended_at - started_at) * 1_000.0
      app
    end

  end
end

