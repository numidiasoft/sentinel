module Sentinel
  class StatusesApi < Grape::API

    desc "return http health statuses for all registred sevices"
    resource :public_statuses do

      route_param :id do
        get do
          user = User.find_by(domain: params[:id])
          http_status = Check.where(visibility: 'public', user: user)
            .desc(:updated_at)
            .page(params[:page] || 1)
            .per(params[:per] || 15)
          present http_status, with: StatusesPresenter
        end
      end
    end

    desc "return a public health status"
    resource :public_status do
      route_param :id do
        get do
          check = Check.where(id: params[:id], visibility: 'public').first
          status 404 and return if check.nil?
          present check, with: StatusPresenter
        end
      end
    end
  end
end
