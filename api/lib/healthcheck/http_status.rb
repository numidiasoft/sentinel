require "faraday"
require_relative "../middleware/faraday_response_time"

module Sentinel
  module HttpStatus

    class << self

      def check(check_entry, timestamp_hour)
        case check_entry.verb
        when "GET"
          result = check_with_get(check_entry, timestamp_hour)
          check_entry.update_attribute(:status, result)
        when "POST"
          result = check_with_post(check_entry, timestamp_hour)
          check_entry.update_attribute(:status, result)
        else
          logger.error("Unknown method #{check_entry.verb} #{self.inspect}")
        end
        check_entry
      end

      def check_with_get(check_entry, timestamp_hour)
        safely do
          response = http_client.get(check_entry.url.to_s)
          check_body(response, check_entry, timestamp_hour)
        end
      end

      def check_with_post(check_entry, timestamp_hour)
        response = http_client.post check_entry.url.to_s do |req|
          req.headers[:content_type] = 'application/json'
          req.body = JSON.parse(check_entry.params).to_json
        end
        check_body(response, check_entry, timestamp_hour)
      end

      private
      def logger
        Sentinel.logger
      end

      def check_body(response, check_entry, timestamp_hour)
        body_status = if check_entry.expected_response == "none"
                        true
                      else
                        check_entry.expected_response == response.body
                      end
        status_metric(check_entry.id, response.status, timestamp_hour)
        response_time_metric(check_entry.id, response.env[:duration], timestamp_hour)
        Level::Http.service_state(response.status, body_status)
      end

      def safely
        begin
          yield
        rescue Exception => e
          logger.info(e.message)
        end
      end

      def try_json(params)
        JSON.parse(params) rescue params
      end

      def status_metric(check_id, status, timestamp_hour)
        value = Value.new(key: Time.now.min, value: status)
        Metric.find_or_update(
          check_id: check_id,
          type: "status",
          timestamp_hour: timestamp_hour,
          value: value
        )
      end

      def response_time_metric(check_id, response_time, timestamp_hour)
        value = Value.new(key: Time.now.min, value: response_time)
        Metric.find_or_update(
          check_id: check_id,
          type: "response_time",
          timestamp_hour: timestamp_hour,
          value: value
        )
      end

      def http_client
       ::Faraday::Connection.new do |builder|
          builder.request :response_time
          builder.adapter Faraday.default_adapter
        end
      end

    end
  end
end

