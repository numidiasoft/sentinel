require "mongoid"
module Sentinel
  class Metric
    include Mongoid::Document
    include Mongoid::Timestamps::Created
    include Mongoid::Timestamps::Updated

    field :type, type: String
    field :num_samples, type: Integer
    field :total_samples, type: Integer
    field :timestamp_hour, type: Time
    validates :type, presence: true
    validates :num_samples, presence: true
    validates :total_samples, presence: true
    validates :timestamp_hour, presence: true
    validates :values, presence: true
    embeds_many :values
    belongs_to :check

    def self.find_or_update(check_id:, type:, timestamp_hour:, value:)
      metric = find_or_initialize_by(check_id: check_id, type: type, timestamp_hour: timestamp_hour)
      if metric.new_record?
        metric.num_samples = 1
        metric.total_samples = value.value
        metric.timestamp_hour = timestamp_hour
        metric.values.push(value)
        metric.save!
      else
        metric.values.push(value)
        metric.num_samples = metric.values.size
        metric.save!
      end
      metric
    end
  end
end

