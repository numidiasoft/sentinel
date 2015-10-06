require "json"

module Sentinel
  module Jobs
    class SlackNotifier
      include ::Sneakers::Worker
      from_queue :slack,
                 :exchange => "alerts"

      def work(msg)
        user_id, message = JSON.parse(msg)

        begin
         Integration.where(user_id: user_id).map {|int| int.ping(message) }
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
