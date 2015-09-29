require "json"

module Sentinel
  module Jobs
    class Aggregator
      include ::Sneakers::Worker
      from_queue :aggregation,
                 :exchange => "aggregation"

      def work(msg)
        check_id, timestamp_hour, enqueue_at = JSON.parse(msg)
        check = Check.where(id: check_id).first
        return reject! if check.nil?
        checker = HealthCheck.checker(check.protocol)
        checker.check(check, timestamp_hour, now_date: enqueue_at.to_time) ? ack! : reject!
      end

      def self.enqueue(*msg)
        publisher_opts = queue_opts.slice(:exchange, :exchange_type)
        publisher = Sneakers::Publisher.new(publisher_opts)
        publisher.publish(msg.to_json, to_queue: queue_name)
        publisher.instance_variable_get(:@bunny).close
      end
    end
  end
end
