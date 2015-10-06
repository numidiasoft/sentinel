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
      x.report(:metrics) do
       MetricAgregator.agregate(check: @check,
                                period: period,
                                agregation: aggregation,
                                type: type)
      end
    end

  end
end

type = ARGV[0] || 'status'

check = Sentinel::Check.last
exit(0) if check.nil?

Sentinel::Benchmark.new(check).get(type: type)

