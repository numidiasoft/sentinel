module Sentinel
  module Influxdb
    class Where
      OPERATOR_MAP = {
        :> => ">",
        :== => "=",
        :< => "<",
        :neq => "<>"
      }

      def initialize(tokens, field, op, value)
        @field = field
        @value = value
        @op = op
        @tokens = tokens
        build()
      end

      def where(field:, op: :==, value:)
        @field = field
        @value = value
        @op = op
        build(first: false) and self
        ResultSet.new(Influxdb::Base.connection, self)
      end

      def to_fql
        @tokens.join("\s")
      end

      private
      def build(first: true)
        if first
          where = "WHERE #{@field} #{OPERATOR_MAP[@op]} #{value}"
        else
          where = "AND #{@field} #{OPERATOR_MAP[@op]} #{value}"
        end
        @tokens << where
      end

      def value
        if @value.kind_of?(String)
          "'#{@value}'"
        else
          @value
        end
      end
    end
  end
end
