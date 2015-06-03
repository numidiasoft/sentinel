
require "spec_helper"

describe Sentinel::User do


  describe "Validations" do
    let(:check) { Sentinel::User.new(password: "hello") }

    specify { expect(check).to validate_presence_of(:first_name) }
    specify { expect(check).to validate_presence_of(:last_name) }
  end

end
