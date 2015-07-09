require "mongoid"
module Sentinel
  class Value
    include Mongoid::Document

    field :key, type: String
    field :value, type: String
    embedded_in :metric
  end
end

