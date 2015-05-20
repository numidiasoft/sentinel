require "spec_helper"

describe Sentinel::Check do


  describe "Validations" do
    let(:check) { Sentinel::Check.new(name: "socialinbox") }

    specify { expect(check).to validate_presence_of(:name) }
    specify { expect(check).to validate_presence_of(:url) }
    specify { expect(check).to validate_presence_of(:protocol) }
    specify { expect(check).to validate_presence_of(:type) }
  end

end
