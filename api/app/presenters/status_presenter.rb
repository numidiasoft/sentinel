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
    property :description
    property :updated_at
    property :protocol
    property :status

    link rel: :self, method: :GET do |opts|
      "/statuses/#{represented.id}"
    end

    link rel: :statuses, method: :PATCH, templated: true do
      "/statuses{?page}"
    end

  end
end

