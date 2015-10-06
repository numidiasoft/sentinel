require "mongoid"
module Sentinel
  class Integration
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Mongoid::Timestamps::Updated

    field :config, type: Hash, default: {}
    field :type
    belongs_to :user


    validates :type, inclusion: { in: ["slack"] }
    validates :type, presence: true
    validates :user_id, presence: true

    def config
      @config ||= ::Hashie::Mash.new(super)
    end

    def ping(message)
     slack_client.notify(message)
    end

    private
    def slack_client
      @client ||= Integrations::SlackNotifier
                    .new(webhook_url: config.webhook_url,
                         channel: config.channel,
                         username: config.username)
    end
  end
end
