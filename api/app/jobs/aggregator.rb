module Sentinel
  module Jobs
    class Aggregator
      include ::Sneakers::Worker
      from_queue :aggregation,
                 :exchange => "aggregation"

      def work(check_id)
        check = Check.where(id: check_id).first
        return reject! if check.nil?
        checker = HealthCheck.checker(check.protocol)
        checker.check(check) ? ack! : reject!
      end

      def self.enqueue(msg)
        publisher_opts = queue_opts.slice(:exchange, :exchange_type)
        publisher = Sneakers::Publisher.new(publisher_opts)
        publisher.publish(msg, to_queue: queue_name)
        publisher.instance_variable_get(:@bunny).close
      end
    end
  end
end
