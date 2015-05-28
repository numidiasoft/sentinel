require "faraday"

module Sentinel
  module HttpStatus

    class << self
      def check(check_entry)
        case check_entry.verb
        when "GET"
          check_entry.update_attribute(:status, check_with_get(check_entry))
        when "POST"
          check_entry.update_attribute(:status, check_with_post(check_entry))
        else
          logger.error("Unknown method #{check_entry.verb} #{self.inspect}")
        end
        check_entry
      end

      def check_with_get check_entry
        safly do
          response = Faraday.get(check_entry.url.to_s)
          check_body(response, check_entry)
        end
      end

      def check_with_post check_entry
        response = Faraday.post(check_entry.url, try_json(check_entry.params))
        check_body(response, check_entry)
      end

      private
      def logger
        Sentinel.logger
      end

      def check_body(response, check_entry)
        body_status = if check_entry.expected_response == "none"
                        true
                      else
                        check_entry.expected_response == response.body
                      end
        Level::Http.service_state(response.status, body_status)
      end

      def safly
        begin
          yield
        rescue Exception => e
          logger.info(e.message)
        end
      end

      def try_json(params)
        JSON.parse(params) rescue params
      end
    end
  end
end

