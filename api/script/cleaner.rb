#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../config/application'

module Sentinel
  Jobs::Cleaner.enqueue("clear", 1.day.ago)
end
