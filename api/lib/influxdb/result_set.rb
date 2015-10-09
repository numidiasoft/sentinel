module Sentinel
  module Influxdb
    class ResultSet
      delegate :to_fql , to: :scope
      delegate :select, to: :scope
      delegate :where, to: :scope

      def initialize(connection, scope)
        @scope = scope
      end

      def entries
        result = Influxdb::Base.connection.query(self.to_fql)
        result.empty? ? [] : result.first["values"]
      end

      def scope
        @scope
      end
    end
  end
end
