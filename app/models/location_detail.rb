class LocationDetail < ApplicationRecord
  validates :address, :type, presence: true
end
