module Sentinel
  class StatusChecks < Grape::API
    format :json
    helpers do
      def logger
       Sentinel.logger
      end
    end

    desc "return http health statuses for all registred sevices"
    resource :statuses do
      get do
        http_status = Check.all
        present http_status, with: StatusesPresenter
      end

      desc "Create a new health status"
      params do
        requires :check, type: Hash do
          requires :name, type: String, desc: 'The name of status'
          requires :url, type: String, desc: 'The enpoint to check'
          requires :type, type: String, desc: 'The type of service to check'
          requires :protocol, type: String, desc: 'The protocol to use', default: :http
        end
      end

      post do
        check  = Check.new(params.check.to_h)
        error!("Check creation failed") unless check.save
        status 200
      end

      desc "Update a new health status"
      params do
        requires :check, type: Hash do
          requires :name, type: String, desc: 'The name of status'
          requires :url, type: String, desc: 'The enpoint to check'
          requires :type, type: String, desc: 'The type of service to check'
          requires :protocol, type: String, desc: 'The protocol to use', default: :http
        end
      end

      patch do
        check = Check.where(id: params[:check][:_id]).first
        status 404 and return if check.nil?
        updated = check.update_attributes(declared(params).check.to_h)
        error!('Check update failed', 400) if updated == false
        present check.reload, with: StatusPresenter
      end

      desc "return a health status for a sepecific service"
      route_param :id do
        get do
         check = Check.where(id: params[:id]).first
         status 404 and return if check.nil?
         present check, with: StatusPresenter
        end
      end

    end
  end
end

