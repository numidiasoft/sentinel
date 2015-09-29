require 'spec_helper'

module Sentinel
  describe HttpStatus do

    let(:expected_response) do
      {
        login:"100",
        id:369826,
        avatar_url:"https://avatars.githubusercontent.com/u/369826?v=3",
        gravatar_id:"",
        url:"https://api.github.com/users/100",
        html_url:"https://github.com/100",
        followers_url:"https://api.github.com/users/100/followers",
        following_url:"https://api.github.com/users/100/following{/other_user}",
        gists_url:"https://api.github.com/users/100/gists{/gist_id}",
        starred_url:"https://api.github.com/users/100/starred{/owner}{/repo}",
        subscriptions_url:"https://api.github.com/users/100/subscriptions",
        organizations_url:"https://api.github.com/users/100/orgs",
        repos_url:"https://api.github.com/users/100/repos",
        events_url:"https://api.github.com/users/100/events{/privacy}",
        received_events_url:"https://api.github.com/users/100/received_events",
        type:"User",
        site_admin:false,
        public_repos:0,
        public_gists:0,
        followers:0,
        following:0,
        created_at:"2010-08-19T15:52:44Z",
        updated_at:"2013-12-15T19:21:11Z"
      }.to_json
    end

    let(:http_check_green) { create(:check, expected_response: expected_response, url: "https://api.github.com/users/100") }
    let(:http_check_yellow) { create(:check, expected_response: "ok", status: :yellow) }
    let(:http_check_red) { create(:check, url: "https://api.github.com/users/100/qdqs", status: :red) }

    let!(:timestamp_hour) { Time.now.strftime("%Y-%m-%dT%H:00:00") }


    context "When status is yellow" do
      describe "#check_with_get" do

        it "should return a status" do
          VCR.use_cassette('http_check_yellow') do
            status = HttpStatus.check_with_get(http_check_yellow, timestamp_hour, Time.now)
            expect(status).to be(:yellow)
          end
        end

      end
    end

    describe "Check" do
      context  "When service is up with GET verb" do
        context "When status and response boby match" do

          it "returns green state for expected response with none value" do
            VCR.use_cassette('http_check_green') do
              check_entry = HttpStatus.check(http_check_green, timestamp_hour)
              expect(check_entry.status.to_sym).to be(:green)
            end
          end

          it "returns green state for expected response with equality" do
            VCR.use_cassette('http_check_green') do
              check_entry = HttpStatus.check(http_check_green, timestamp_hour)
              expect(check_entry.status.to_sym).to be(:green)
            end
          end

        end

        context "When matches only status" do

          it "returns yellow status" do
            VCR.use_cassette('http_check_yellow') do
              check_entry = HttpStatus.check(http_check_yellow, timestamp_hour)
              expect(check_entry.status.to_sym).to be(:yellow)
            end
          end

        end

        context "When service is up with POST verb" do

          let(:http_post_check_green) do
            create(:check,
                   verb: :POST,
                   url: 'http://fixedbikesshop.sandbox.sleekapp.io/api/login',
                   expected_response: '{}',
                   params: '{"email": "tarik.ihadjadene@tigerlilyapps.com", "password": "aaaaaa"}');
          end
          let(:http_post_check_yellow) { create(:check, expected_response: "ok", status: :yellow, verb: :POST) }
          let(:http_post_check_red) { create(:check, url: "https://api.github.com/users/100/qdqs", status: :red, verb: :POST) }

          it "returns green state" do
            VCR.use_cassette(:http_post_check_green) do
              check_entry = HttpStatus.check(http_post_check_green, timestamp_hour)
              expect(check_entry.metrics.size).to be(2)
              expect(check_entry.metrics.first.values.size).to be(1)
              expect(check_entry.status.to_sym).to be(:green)
            end
          end

        end
      end

      context "When status is down" do

        it "returns red status" do
          VCR.use_cassette('http_check_red') do
            check_entry = HttpStatus.check(http_check_red, timestamp_hour)
            expect(check_entry.status.to_sym).to be(:red)
          end
        end

      end
    end
  end
end
