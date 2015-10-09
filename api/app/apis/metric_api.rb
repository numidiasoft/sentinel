module Sentinel
  class MetricApi < Grape::API
    format :json

    desc "return mertics for a status"
    resource :metrics do
      route_param :id do
        get do
          check = Check.where(id: params[:id]).first
          error!('Not found', 404) if check.nil?
          type = params[:type] || 'status'
          period = params[:since] || 'day'
          time  = MetricAgregator.calculate_since(period)
          agregated = Influxdb::Base.select(type, select: %w(response_time date))
            .where(field: :check_id, value: check.id.to_s)
            .where(field: :time, op: :>, value: Influxdb::Base.format_time(time))
            .entries
          return agregated
        end
      end
    end
  end
end
