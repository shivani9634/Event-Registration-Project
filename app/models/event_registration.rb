class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :discount_code, optional: true
  validates :id_proof, :final_fee, :registration_date, :status, :no_of_people, presence: true
  validates :status, inclusion: { in: [ "Pending", "Confirmed", "Cancelled" ] }
  validate :limit_tickets_per_user
  private

  def limit_tickets_per_user
    if no_of_people > 3
      errors.add(:no_of_people, "You can only register up to 3 people per event.")
    end
  end
end
