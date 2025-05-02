# == Schema Information
#
# Table name: location_details
#
#  id            :integer          not null, primary key
#  address       :text             not null
#  location_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class LocationDetail < ApplicationRecord
  # Validations
  validates :address, presence: true, length: { maximum: 100 }
  validates :location_type, presence: true, length: { maximum: 100 }
end
