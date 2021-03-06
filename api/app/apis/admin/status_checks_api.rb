module Sentinel
  class StatusChecksApi < Grape::API
    format :json

    helpers do
      def current_user
        @user ||= User.where(id: session[:user_id]).first
      end
    end

    desc "return http health statuses for all registred sevices"
    resource :statuses do
      before do
        error!('Unauthorized', 401) unless current_user
      end

      get do
        http_status = Check.where(user: current_user)
          .desc(:updated_at)
          .page(params[:page] || 1)
          .per(params[:per] || 15)
        present http_status, with: StatusesPresenter
      end

      desc "Create a new health status"
      params do
        requires :check, type: Hash do
          requires :name, type: String, desc: 'The name of status'
          requires :url, type: String, desc: 'The enpoint to check'
          optional :description, type: String, desc: 'The description ofcheck'
          optional :expected_response, type: String, desc: 'The expected response'
          requires :type, type: String, desc: 'The type of service to check'
          requires :protocol, type: String, desc: 'The protocol to use', default: :auto
          requires :verb, type: String, desc: 'The verb to use', default: :GET
          optional :params, type: String, desc: 'params'
        end
      end

      post do
        check  = Check.new(params.check.to_h.merge(user_id: current_user.id))
        error!("Check creation failed #{check.errors.first}", 400) unless check.save
        present check.reload, with: StatusPresenter
      end

      desc "Update a new health status"
      params do
        requires :check, type: Hash do
          requires :name, type: String, desc: 'The name of status'
          requires :url, type: String, desc: 'The enpoint to check'
          requires :type, type: String, desc: 'The type of service to check'
          optional :description, type: String, desc: 'The description of check'
          optional :expected_response, type: String, desc: 'The expected response'
          requires :protocol, type: String, desc: 'The protocol to use', default: :http
          requires :verb, type: String, desc: 'The verb to use', default: :GET
          requires :visibility, type: String, desc: 'The visibility of the status', default: :private
          optional :params, type: String, desc: 'params'
        end
      end

      patch do
        check = Check.where(id: params[:check][:_id]).first
        status 404 and return if check.nil?
        updated = check.update_attributes(declared(params).check.to_h)
        error!("Check update failed #{check.errors.first}", 400) if updated == false
        present check.reload, with: StatusPresenter
      end

      desc "Delete a status."
      params do
        requires :id, type: String, desc: "Status ID."
      end

      delete ':id' do
        check = Check.where(id: params[:id]).first
        error!('Not found', 404) if check.nil?
        error!('Failed to destroy', 400) unless check.destroy
        status 200
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

