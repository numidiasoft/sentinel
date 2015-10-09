require 'influxdb'
module Sentinel
  module Influxdb
    module Base
      extend self
      def connection
        require 'influxdb'
        @connection ||= ::InfluxDB::Client.new( Config.application.influxdb.database,
                                           username: Config.application.influxdb.username,
                                           password: Config.application.influxdb.password,
                                           host: Config.application.influxdb.host,
                                           port: Config.application.influxdb.port)
      end

      def select(measurement, select: [])
        select = Select.new(measurement, select: select)
        ResultSet.new(connection, select)
      end

      def reset_database(database)
        connection.delete_database(database)
        connection.create_database(database)
      end

      def format_time(time)
        time.utc.strftime("%Y-%m-%d %H:%M:%S.%3N")
      end
    end
  end
end
