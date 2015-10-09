module Sentinel
  module Influxdb
    class Select
      def initialize(measurement, select: [])
        @measurement = measurement
        @select = select
        @tokens = []
        base()
      end

      def where(field:, op: :==, value:)
        where = Where.new(@tokens, field, op, value)
        ResultSet.new(Influxdb::Base.connection, where)
      end

      def to_fql
        @tokens.join("\s")
      end

      private
      def base
        select = @select.empty? ? "*" : @select.join(",")
        @tokens << "SELECT #{select} FROM #{@measurement}"
        self
      end
    end
  end
end
