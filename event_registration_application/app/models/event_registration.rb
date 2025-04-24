class EventRegistration < ApplicationRecord
  belongs_to :event

  validates :id_proof, :final_fee, :registration_date, :status, :no_of_people, presence: true
  validates :status, inclusion: { in: [ "Pending", "Confirmed", "Cancelled" ] }
end
