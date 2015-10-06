require "spec_helper"

module Sentinel
  describe  Integration do
    let(:integration) do
      described_class.new(type: "slack", config: { webhook_url: "http://webhook.dz/1234598"})
    end

    specify { expect(integration).to validate_presence_of(:type) }
    specify { expect(integration).to validate_presence_of(:user_id) }

    it "returns the config field as a Hashie::Mash object " do
      expect(integration.config).to be_instance_of(Hashie::Mash)
    end
  end
end
