require "spec_helper"

module Sentinel
  describe Influxdb::Base do

    it "returns an instance of incfluxdb client" do
      VCR.use_cassette(:influxdb_client) do
        expect(described_class.connection).to be_kind_of(::InfluxDB::Client)
      end
    end

    it "builds a select request" do
      result = described_class.select(:status, select: [:check_id])
      expect(result).to be_kind_of(Influxdb::ResultSet)
      expect(result.to_fql).to eql("SELECT check_id FROM status")
    end

    it "builds a select with where filter a returns results" do
      result = described_class.select(:status, select: [:check_id])
                      .where(field: :time, op: :>, value: "now() -1")
                      .where(field: :check_id, op: :==, value: "124587")
      expect(result).to be_kind_of(Influxdb::ResultSet)

      VCR.use_cassette(:influxdb_where) do
        expect(result.entries).to be_eql([])
      end
    end

  end
end
