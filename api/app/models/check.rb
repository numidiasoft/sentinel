require "mongoid"
module Sentinel
  class Check
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Mongoid::Timestamps::Updated

    field :name, type: String
    field :url, type: String
    field :type, type: String
    field :protocol, type: String
    field :expected_response, type: String, default: :none
    field :description, type: String
    field :verb, type: String
    field :params, type: String
    field :status, type: String, default: 'green'
    field :visibililty, type: String, default: 'private'
    validates :name, presence: true
    validates :url, presence: true
    validates :type, presence: true
    validates :protocol, presence: true
    validates :expected_response, presence: true
    validates :status, inclusion: { in: ['red', 'green', 'yellow'] }
    validates :type, inclusion: { in: ['auto', 'manual'] }
    validates :verb, inclusion: { in: ['GET', 'POST', 'PATCH'] }
    validates :visibililty, inclusion: { in: ['private', 'public'] }

    belongs_to :user
    has_many :metrics
  end
end
