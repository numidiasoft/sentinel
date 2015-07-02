
require 'spec_helper'
module Sentinel
  describe AuthenticationApi do

    let(:user) do
      create :user
    end


    describe "POST authentication" do

      it "returns success http status" do
        params = user.attributes
        post 'authentication', params.merge(password: "password")
        expect(last_response.status).to be(200)
      end

      it "return forbidden http status" do
        params = user.attributes
        post 'authentication', params.merge(password: "wrong_password")
        expect(last_response.status).to be(403)
      end

    end

    describe "GET authentication" do

      it "returns the session" do
        login(user)
        get 'authentication'
        expect(last_response.status).to be(200)
        body = Hash[JSON.parse(last_response.body)]
        expect(body['user_id']).to eql(user.id.to_s)
      end

      it "returns a forbidden" do
        get 'authentication'
        expect(last_response.status).to be(401)
      end

    end

  end
end
