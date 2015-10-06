#!/usr/bin/env ruby
# encoding: utf-8

require_relative '../config/application'

module Sentinel
  module Scripts
    module Cleaner
      extend self
      def process
        (1..self.pages).each do |page|
          check_ids = self.load_check_ids_for_page(page)
          Jobs::Cleaner.enqueue(check_ids, 1.day.ago)
        end
      end

      def load_check_ids_for_page(page)
        Check.where(type: :auto).page(page).per(50).map(&:id).map(&:to_s)
      end

      def pages
        Check.pages
      end
    end
  end
end

Sentinel::Scripts::Cleaner.process
