require "faraday"

module Sentinel
  module HttpStatus

    class << self
      def check(check_entry)
        case check_entry.type
        when "GET"
          check_entry.update_attribute(:status, check_with_get(check_entry))
        when "POST"
        else
          logger.error("Unknown method for #{self.class}")
        end
        check_entry
      end

      def check_with_get check_entry
        safly do
          response = Faraday.get(check_entry.url.to_s)
          body_status = if check_entry.expected_response == "none"
                          true
                        else
                          check_entry.expected_response == response.body
                        end
          Level::Http.service_state(response.status, body_status)
        end
      end

      def check_with_post check
        #TODO
      end

      private
      def logger
        Sentinel.logger
      end

      def safly
        begin
          yield
        rescue Exception => e
          logger.info(e.message)
        end
      end
    end
  end
end

