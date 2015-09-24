require 'spec_helper'
module Sentinel
  describe HealthCheck do

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

    let(:checks) do
      5.times { create :check, expected_response: expected_response }
    end

    context ".checker" do

      it "returns an http checker" do
        expect(described_class.checker(:http)).to be(HttpStatus)
      end

      it "returns the default checker" do
        expect(Sentinel.logger).to receive(:error).with('uninitialized constant NoneStatus')
        expect(described_class.checker(:none)).to be(Sentinel::HealthCheck)
      end

    end

    describe ".check" do

      it "logs an error" do
        check_entry = create(:check)
        expect(Sentinel.logger).to receive(:error).with('uninitialized constant Sentinel::HttpStatus')
        described_class.check(check_entry, async: false)
      end

    end

    describe ".check_all" do

      it "returns the checks status" do
        VCR.use_cassette('health_check_green') do
          checks
          results = described_class.check_all(async: false)
          expect(results.size).to eql(5)
          results.each do |result|
            expect(result[:status].to_sym).to be(:green)
          end
        end
      end

    end

  end
end
