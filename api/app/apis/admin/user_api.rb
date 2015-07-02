module Sentinel
  class UserApi < Grape::API
    format :json

    helpers do
      def current_user
        @user ||= User.where(id: session[:user_id]).first
      end
    end

    desc "return http health statuses for all registred sevices"
    resource :me do
      before do
        error!('Unauthorized', 403) unless current_user
      end

      get do
        present current_user, with: UserPresenter
      end

    end
  end
end

