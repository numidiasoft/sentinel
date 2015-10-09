require "influxdb"
module Sentinel
  module Influxdb
    autoload :Select, "./lib/influxdb/select.rb"
    autoload :Where, "./lib/influxdb/where.rb"
    autoload :Base, "./lib/influxdb/base.rb"
    autoload :ResultSet, "./lib/influxdb/result_set.rb"
  end
end
