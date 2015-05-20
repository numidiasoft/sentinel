require 'roar/decorator'

module Sentinel
 class StatusPresenter < Grape::Roar::Decorator
    include Roar::JSON::HAL
    include Roar::Hypermedia

    property :id
    property :name
    property :url
    property :type
    property :expected_response
    property :protocol
    property :status

    link rel: :self, method: :GET do |opts|
      "/status/#{represented.id}"
    end

  end
end

