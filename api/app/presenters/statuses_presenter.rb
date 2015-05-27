require 'roar/decorator'

module Sentinel
 class StatusesPresenter < Grape::Roar::Decorator
    include Roar::JSON::HAL
    include Roar::Hypermedia


    collection :entries, extend: StatusPresenter, as: :statuses

    link rel: :self, method: :GET, templated: true do |opts|
      '/statuses{?page}'
    end
  end
end

