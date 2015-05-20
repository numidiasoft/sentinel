require 'spec_helper'

module Sentinel
  describe Level do

    context "Http levels" do
      describe "#service_status" do

        it "returns green" do
          expect(Level::Http.service_state(200, true)).to be(:green)
        end

        it "returns yellow" do
          expect(Level::Http.service_state(200, false)).to be(:yellow)
        end

        it "return red" do
          expect(Level::Http.service_state(500)).to be(:red)
        end

        it "return red" do
          expect(Level::Http.service_state(403)).to be(:red)
        end
      end
    end
  end
end
