module Sentinel
  class MetricApi < Grape::API
    format :json

    desc "return mertics for a status"
    resource :metrics do
      route_param :id do
        get do
          check = Check.where(id: params[:id]).first
          error!('Not found', 404) if check.nil?
          agregation = params[:agregation] || 'minutes'
          type = params[:type] || 'status'
          period = params[:since] || 'day'
          agregated = MetricAgregator.agregate(check: check, period: period, agregation: agregation, type: type)
          present agregated
        end
      end
    end
  end
end
