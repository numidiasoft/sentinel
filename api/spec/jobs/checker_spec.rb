require "spec_helper"

module Sentinel
  describe  Jobs::Checker do
    let(:enqueue) do
      -> (*msg) { described_class.enqueue(*msg) }
    end

    let(:worker) { described_class.new }
    let(:timestamp_hour) { Time.now.strftime("%Y-%m-%dT%H:00:00") }
    let(:bunny) do
      double("Bunny", close: :closed)
    end

    it "publishes message to the queue" do
      msg = [1, timestamp_hour, Time.now]
      expect_any_instance_of(Sneakers::Publisher)
        .to receive(:instance_variable_get).and_return(bunny)
      expect_any_instance_of(Sneakers::Publisher)
        .to receive(:publish)
        .with(msg.to_json, to_queue: "checker")

      result = enqueue.(msg.first, msg.second, msg.last)
      expect(result).to be(:closed)
    end

    it "returns reject verb"  do
      message =  [1, timestamp_hour, Time.now].to_json
      result = worker.work(message)
      expect(result).to be(:reject)
    end

    it "return ack verb" do
      check = create(:check)
      message = [check.id.to_s, timestamp_hour, Time.now].to_json
      VCR.use_cassette('http_check_yellow') do
        result = worker.work(message)
        expect(result).to be(:ack)
      end
    end
  end
end
