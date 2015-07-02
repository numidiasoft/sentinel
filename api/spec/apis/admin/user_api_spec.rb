require 'spec_helper'

module Sentinel
  describe UserApi do
    let(:current_user) { create :user }

    describe 'GET /me' do
      context 'When user is authenticated' do
        it 'returns the user infos' do
          login(current_user)
          get 'me'
          response  = JSON.parse(last_response.body)
          expect(response['email']).to eql(current_user.email)
          expect(response['first_name']).to eql(current_user.first_name)
        end
      end

      context 'When user is not authenticated' do
        it 'returns and error' do
          get 'me'
          expect(last_response.status).to eql(403)
        end
      end
    end

  end
end
