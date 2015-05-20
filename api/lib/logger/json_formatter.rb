require 'grape_logging'
module Sentinel
  class JsonFormatter < ::GrapeLogging::Formatters::Default

    def call(severity, datetime, _, data)
      @severity = severity
      @datetime = datetime
      format(data)
    end

    def format(data)
      case data
      when Exception
        format_exception(data)
      when Hash
        format_hash(data)
      else
        format_default(data)
      end
    end

    private
    def format_default(data)
      "#{{ datetime: @datetime.to_s, severity: @severity, message: data }}\n"
    end

    def format_hash(data)
      data = { message: data }
      "#{data.merge(datatime: @datetime.to_s, severity: @severity)}\n"
    end

    def format_exception(data)
      "#{{ datetime: @datetime.to_s, severity: @severity, message: super(data)}}\n"
    end

  end
end

