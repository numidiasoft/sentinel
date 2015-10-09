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
    field :visibility, type: String, default: 'private'
    validates :name, presence: true
    validates :url, presence: true
    validates :type, presence: true
    validates :protocol, presence: true
    validates :expected_response, presence: true
    validates :status, inclusion: { in: ['red', 'green', 'yellow'] }
    validates :type, inclusion: { in: ['auto', 'manual'] }
    validates :verb, inclusion: { in: ['GET', 'POST', 'PATCH'] }
    validates :visibility, inclusion: { in: ['private', 'public'] }

    after_save :apply_integrations

    belongs_to :user
    has_many :metrics

    index({ user_id: 1, visibility: 1, updated_at: 1 }, { unique: false, name: "composite_index" })

    def self.pages(per_page: 50)
      total_number = Check.count
      pages = total_number/per_page
      pages = pages + 1 if total_number.modulo(per_page) != 0
      pages.zero? ? 1 : pages
    end

    def apply_integrations
      return if user.integrations.empty?
      status_changes = changes["status"]
      unless status_changes.nil?
        message = "Alert: #{self.description}(#{self.id}) passed from #{status_changes.first} to #{status_changes.last}"
        Jobs::SlackNotifier.enqueue(self.user_id.to_s, message)
      end
    end
  end
end
