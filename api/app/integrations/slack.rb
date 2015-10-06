require "slack-notifier"

module Sentinel
  module Integrations
    class SlackNotifier
      def initialize(webhook_url: webhook_url, channel: '#default', username: 'sentinel')
        @webhook_url = webhook_url
        @client = ::Slack::Notifier.new(webhook_url, channel: channel, username: username)
      end

      def notify(message)
        @client.ping(message)
      end

      def client
        @client
      end
    end
  end
end

