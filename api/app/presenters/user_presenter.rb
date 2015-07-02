require 'roar/decorator'

module Sentinel
 class UserPresenter < Grape::Roar::Decorator
    include Roar::JSON::HAL
    include Roar::Hypermedia

    property :id
    property :first_name
    property :last_name
    property :email
    property :domain

    link rel: :self, method: :GET do |opts|
      "/me"
    end

  end
end

