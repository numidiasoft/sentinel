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
        check.metrics.where(:created_at.gte => since, type: type).order_by(:created_at.asc).map do |metric|
          {
            :date  => to_iso_8601(metric.created_at),
            type =>  metric.total_samples
          }
        end
      end

      def agregate_by_minute(check, type, since)
        metrics = check.metrics
          .where(:created_at.gte => since, type: type)
          .order_by(:created_at.asc)
          .inject([], :<<)
        minute_metric_values(metrics)
      end

      def minute_metric_values(metrics)
        metrics.map do |metric |
          metric.values.map do |value|
          payload(metric, value)
          end
        end.flatten
      end

      def set_influxdb_metrics(check:)
        %w(status response_time).each do |metric_type|
          data = self.agregate(type: metric_type, check: check)
          Influxdb::Base.connection.write_points(data)
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

      def payload(metric, value)
        delay = (value.key.to_i - metric.created_at.min).minutes
        {
          :date => to_iso_8601(metric.created_at + delay),
          metric.type => value.value,
          :series => metric.type,
          :values => {
          metric.type => value.value.to_f.round(2),
          date: to_iso_8601(metric.created_at + delay),
          check_id: metric.check_id.to_s
        },
          :timestamp => to_iso_8601(metric.created_at + delay).to_time.to_i,
        }
      end
    end
  end
end
