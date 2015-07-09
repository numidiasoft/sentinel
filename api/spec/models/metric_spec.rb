require "spec_helper"

module Sentinel
  RSpec.describe Metric do
    let(:check) { Sentinel::Check.new(name: "socialinbox") }
    let(:metric) { create :metric, check: check}

    describe '.find_or_create' do

      it 'creates a new metric' do
        timestamp_hour = Time.now
        value = Value.new(key: timestamp_hour.sec, value: 325)
        metric = Metric.find_or_update(check_id: check.id, type: 'response_time', timestamp_hour: timestamp_hour, value: value)
        expect(metric.valid?).to be(true)
        expect(metric.values.size).to eql(1)
        expect(metric.values.first).to eql(value)
      end

      it "loads an existing metric" do
        metric
        value = Value.new(key: metric.timestamp_hour.sec, value: 325)
        new_metric = Metric.find_or_update(check_id: check.id, type: 'response_time', timestamp_hour: metric.timestamp_hour, value: value)
        expect(new_metric.valid?).to eql(true)
        expect(metric.id).to eql(new_metric.id)
      end
    end
  end
end

