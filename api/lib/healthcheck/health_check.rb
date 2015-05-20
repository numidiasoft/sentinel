module Sentinel
  module HealthCheck

    class << self

      def check_all
        status = []
        Check.all.each do |check_entry|
          result = checker(check_entry.protocol)
            .check(check_entry)
          status << check_entry.attributes
        end
        status
      end

      def check(check_entry)
        Sentinel.logger.error("uninitialized constant Sentinel::#{check_entry.protocol.capitalize}Status")
      end

      def checker(protocol)
        begin
          "Sentinel::#{protocol.capitalize}Status".constantize
        rescue  NameError => e
          Sentinel.logger.error(e.message)
          self
        end
      end
    end

  end
end
