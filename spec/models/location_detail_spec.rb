# spec/models/location_detail_spec.rb

require 'rails_helper'

RSpec.describe LocationDetail, type: :model do
  subject {
    described_class.new(
      address: "1234 Ruby St, Code City",
      location_type: "Event Venue"
    )
  }

  describe "Validations" do
    it { should validate_presence_of(:address) }
    it { should validate_length_of(:address).is_at_most(100) }

    it { should validate_presence_of(:location_type) }
    it { should validate_length_of(:location_type).is_at_most(100) }
  end
end
