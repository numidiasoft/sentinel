module Sentinel
  module HealthCheck
    PER_PAGE = 50

    class << self

      def check_all(async: false)
        [].tap do |statuses|
          (1..pages).each do |page|
            Check.where(type: :auto).page(page).per(PER_PAGE).each do |check_entry|
              progress_bar.increment
              timestamp_hour = Time.now.strftime("%Y-%m-%dT%H:00:00")
              statuses << process(check_entry, timestamp_hour, async: async)
            end
          end
        end
      end

      def process(check_entry, timestamp_hour, async:)
        if async == true
          Jobs::Checker.enqueue(check_entry.id.to_s, timestamp_hour, Time.now)
        else
          checker = checker(check_entry.protocol)
          checker.check(check_entry, timestamp_hour, now_date: Time.now)
          check_entry.attributes
        end
      end

      def check(check_entry, timestamp_hour, now_date: Time.now)
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
        Check.pages(per_page: PER_PAGE)
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
