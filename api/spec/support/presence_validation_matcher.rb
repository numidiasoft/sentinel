require 'rspec/expectations'

RSpec::Matchers.define :validate_presence_of do |expected_attribute|
  match do |model|
    model.assign_attributes(expected_attribute => nil)
    model.valid?
    expect(model.errors.messages[expected_attribute]).to include "can't be blank"
  end
end
