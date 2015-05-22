module Sentinel
  module HealthCheck
    PER_PAGE = 50

    class << self

      def check_all
        statuses = []
        (1..pages).each do |page|
          Check.page(page).per(PER_PAGE).each do |check_entry|
            progress_bar.increment
            result = checker(check_entry.protocol)
            .check(check_entry)
            statuses << check_entry.attributes
          end
        end
        statuses
      end

      def check(check_entry)
        Sentinel.logger
          .error("uninitialized constant Sentinel::#{check_entry.protocol.capitalize}Status")
      end

      def checker(protocol)
        begin
          "Sentinel::#{protocol.capitalize}Status".constantize
        rescue  NameError => e
          Sentinel.logger.error(e.message)
          self
        end
      end

      private
      def pages
        pages = total_number / PER_PAGE
        pages = pages + 1 if total_number.modulo(PER_PAGE) != 0
        pages.zero? ? 1 : pages
      end

      def logger
        Sentinel.logger
      end

      def total_number
        @total ||= Check.count
      end

      def progress_bar
        @progress_bar ||= ProgressBar.new(total_number)
      end

    end

  end
end
