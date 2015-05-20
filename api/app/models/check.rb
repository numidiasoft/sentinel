require "mongoid"
module Sentinel
  class Check
    include Mongoid::Document
    field :name, type: String
    field :url, type: String
    field :type, type: String
    field :protocol, type: String
    field :expected_response, type: String, default: :none
    field :status, type: String, default: 'green'
    validates :name, presence: true
    validates :url, presence: true
    validates :type, presence: true
    validates :protocol, presence: true
    validates :expected_response, presence: true
    validates :status, inclusion: { in: ['warning', 'green', 'yellow'] }
    validates :type, inclusion: { in: ['GET', 'POST', 'PATCH'] }

  end
end
