require "json"

module Sentinel
  module Jobs
    class Cleaner
      include ::Sneakers::Worker
      from_queue :cleaner,
                 :exchange => "aggregation"

      def work(msg)
        check_ids, since = JSON.parse(msg)
        begin
          Metric
            .where(:created_at.lte => (since.to_time || 1.days.ago), :check_id.in => check_ids)
            .delete
          ack!
        rescue Exception => e
          #TODO send errors to sentry
          reject!
        end
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
