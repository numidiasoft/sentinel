require 'spec_helper'

module Sentinel
  describe HttpStatus do

    let(:http_check_green) { create(:check) }
    let(:http_check_yellow) { create(:check, expected_response: "ok", status: :yellow) }
    let(:http_check_red) { create(:check, url: "https://api.github.com/users/100/qdqs", status: :red) }


    context "When status is yellow" do
      describe "#check_with_get" do

        it "should return a status" do
          VCR.use_cassette('http_check_yellow') do
            status = HttpStatus.check_with_get(http_check_yellow)
            expect(status).to be(:yellow)
          end
        end

      end
    end

    describe "Check" do
      context "When service is up" do
        context "When status and response boby match" do

          it "returns green state for expected response with none value" do
            VCR.use_cassette('http_check_green') do
              check_entry = HttpStatus.check(http_check_green)
              expect(check_entry.status.to_sym).to be(:green)
            end
          end

          it "returns green state for expected response with equality" do
            VCR.use_cassette('http_check_green') do
              check_entry = HttpStatus.check(http_check_green)
              expect(check_entry.status.to_sym).to be(:green)
            end
          end

        end

        context "When matches only status" do

          it "returns yellow status" do
            VCR.use_cassette('http_check_yellow') do
              check_entry = HttpStatus.check(http_check_yellow)
              expect(check_entry.status.to_sym).to be(:yellow)
            end
          end

        end

      end

      context "When status is down" do

        it "returns red status" do
          VCR.use_cassette('http_check_red') do
            check_entry = HttpStatus.check(http_check_red)
            expect(check_entry.status.to_sym).to be(:red)
          end
        end

      end
    end
  end
end
