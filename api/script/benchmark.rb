#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../config/application'
require 'colorize'
require 'benchmark'

module Sentinel
  class Benchmark

    def initialize(check)
      @check = check
    end

    def get(period: 'day', since: 'day', type: 'status', aggregation: 'minutes')
      ::Benchmark.bm do |x|
        metrics(x, period, aggregation, type)
      end
    end

    private
    def metrics(x, period, aggregation, type)
      x.report("Metrics with Mongo") do
        MetricAgregator.agregate(check: @check,
                                 period: period,
                                 agregation: aggregation,
                                 type: type)
      end

       x.report("Metrics with influxdb") do
         Influxdb::Base.select(:status)
           .where(field: :time, op: :>, value: 'now() - 1d')
           .where(field: :check_id, value: @check.id.to_s)
           .entries
       end
    end

  end
end

type = ARGV[0] || 'status'

check = Sentinel::Check.last
exit(0) if check.nil?

Sentinel::Benchmark.new(check).get(type: type)

