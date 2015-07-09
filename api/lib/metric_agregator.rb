module Sentinel
  module MetricAgregator
    class << self
      def agregate(check:, agregation: 'minutes', period: 'day', type: 'status')
        since = calculate_since(period)
        if agregation == 'hour'
          agregate_by_hour(check, type, since)
        else
          agregate_by_minute(check, type, since)
        end
      end

      def agregate_by_hour(check, type, since)
        check.metrics.where(:timestamp_hour.gte => since, type: type).map do |metric|
          {  metric.timestamp_hour.to_i => metric.total_samples }
        end
      end

      def agregate_by_minute(check, type, since)
        metrics = []
        check.metrics.where(:timestamp_hour.gte => since, type: type).each do |metric|
          metrics << minute_metric_values(metric)
        end
        metrics.flatten
      end


      def minute_metric_values(metric)
        metric.values.map do |value|
          { metric.timestamp_hour + value.key.to_i.minute => value.value.to_i}
        end
      end

      def calculate_since(period)
         accepted_periods =  %w(hour day week month)
         if accepted_periods.include?(period)
          return 1.send(period).ago
         end
         return 1.day.ago
      end
    end
  end
end
