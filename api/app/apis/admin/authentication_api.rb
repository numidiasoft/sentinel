module Sentinel
  class AuthenticationApi <  Grape::API

    desc "Authenticate the user"
    resource :authentication do
      post do
        user = User.where(email: params[:email]).first
        error!('Acess Fobidden', 403) unless user
        error!('Acess Fobidden', 403) unless user.authenticate(params[:password])
        session[:user_id] = user.id.to_s
        status 200
      end

      get do
        error!('Unauthorized', 401) if session['user_id'].nil?
        present session
      end

      delete do
        session.destroy
        status 200
      end
    end
  end
end
