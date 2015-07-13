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
        check.metrics.where(:created_at.gte => since, type: type).map do |metric|
          {
            :date  => to_iso_8601(metric.created_at),
            type =>  metric.total_samples
          }
        end
      end

      def agregate_by_minute(check, type, since)
        metrics = []
        check.metrics.where(:created_at.gte => since, type: type).each do |metric|
          metrics << minute_metric_values(metric)
        end
        metrics.flatten
      end


      def minute_metric_values(metric)
        metric.values.map do |value|
          delay = (value.key.to_i - metric.created_at.min).minutes
          {
            :date => to_iso_8601(metric.created_at + delay),
            metric.type => value.value.to_i
          }
        end
      end

      def calculate_since(period)
        accepted_periods =  %w(hour day week month)
        if accepted_periods.include?(period)
          return 1.send(period).ago
        end
        return 1.day.ago
      end

      def to_iso_8601(time)
        time.strftime("%Y-%m-%dT%H:%M:%SZ")
      end
    end

  end
end
