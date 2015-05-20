require 'roar/decorator'

module Sentinel
 class StatusesPresenter < Grape::Roar::Decorator
    include Roar::JSON::HAL
    include Roar::Hypermedia


    collection :entries, extend: StatusPresenter, as: :statuses

    link rel: :self, method: :GET do |opts|
      '/statuses'
    end
  end
end

