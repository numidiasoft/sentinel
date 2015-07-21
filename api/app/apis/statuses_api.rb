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
  end
end
