require 'spec_helper'
module Sentinel
  describe StatusChecks do

    let(:create_statuses) do
      2.times { create :check }
    end

    let(:create_status) do
      create :check
    end

    describe 'GET /statuses'do
      context 'When checks is empty' do

        it 'returns an empty array' do
          get 'statuses'
          response  = JSON.parse(last_response.body)
          expect(response['statuses']).to eql []
          expect(response.keys.sort).to eql %w(_links statuses).sort
        end

      end

      context 'When checks is not empty' do

        let(:expected_response) do
          response = StatusesPresenter.new(Sentinel::Check.all).to_json
          JSON.parse(response)
        end

        it 'returns a list of statuses' do
          create_statuses
          get 'statuses'
          response  = JSON.parse(last_response.body)
          expect(response['statuses']).to_not be_empty
          expect(response['statuses']).to eql(expected_response['statuses'])
        end

      end
    end

    describe 'GET /status/:id' do
      context 'When status exists' do

        it 'returns a status' do
          status = create_status
          get "/statuses/#{status.id}"
          expect(last_response.body).to_not be_empty
        end

      end

      context 'When status doesn\'t' do

        it 'returns a not found status' do
          get '/statuses/1234430'
          expect(last_response.status).to be(404)
        end

      end
    end

    describe 'POST status' do
      context 'When status is valid' do

        it 'creates a status' do
          new_status = build(:check).attributes.tap { |hs| hs.delete('_id') }
          post '/statuses', check: new_status
          expect(last_response.status).to be(201)
          expect(Check.all.size).to eql(1)
        end

      end

      context 'When status is not valid' do

        it 'returns error' do
          new_status = build(:check).attributes.tap { |hs| hs.delete('_id') }
          post '/statuses', check: new_status.merge(name: '')
          expect(last_response.status).to be(400)
        end

      end
    end

    context 'When status is not valid' do
    end

    describe 'PATH status' do
      context 'When status is valid' do

        it "updates the status" do
          status =  create_status.attributes.merge(name: 'Github')
          patch '/statuses', check: status
          expect(JSON.parse(last_response.body)['name']).to eql('Github')
        end

      end

      context 'When status is not valid' do

        it 'returns error' do
          status =  create_status.attributes.merge(name: '')
          patch '/statuses', check: status
          expect(last_response.status).to be(400)
        end

      end

      context 'When status doesn\'t exist' do
        it 'returns not found status' do
          create_status.id =  '126474848'
          status =  create_status.attributes.merge(id: '12488494')
          patch '/statuses', check: status
          expect(last_response.status).to be(404)
        end
      end
    end

  end
end
