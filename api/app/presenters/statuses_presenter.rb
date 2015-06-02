require 'roar/decorator'

module Sentinel
 class StatusesPresenter < Grape::Roar::Decorator
    include Roar::JSON::HAL
    include Roar::Hypermedia


    collection :entries, extend: StatusPresenter, as: :statuses

    link rel: :self, method: :GET, templated: true do |opts|
      '/statuses{?page}'
    end

    link rel: 'statuses/delete', method: :DELETE, templated: true do
      "/statuses/{id}"
    end

    link rel: 'next' do
      if !represented.next_page.nil?
        "/statuses?page=#{represented.next_page}"
      end
    end
  end
end

