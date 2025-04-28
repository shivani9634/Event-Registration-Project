class LocationDetail < ApplicationRecord
  # Validations
  validates :address, presence: true, length: { maximum: 100 }
  validates :location_type, presence: true, length: { maximum: 100 }
end
