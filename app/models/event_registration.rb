class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :discount_code, optional: true
  before_save :apply_discount

  # Basic Validations
  validates :id_proof, presence: true
  validates :registration_date, presence: true
  validates :status, presence: true, inclusion: { in: [ "Pending", "Confirmed", "Cancelled" ] }
  validates :no_of_people, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # Custom Validations
  validate :limit_tickets_per_user
  validate :event_should_have_enough_capacity
  validate :event_should_be_open_for_registration
  validate :unique_registration_per_user, on: :create

  private

  # Limit no of people per registration
  def limit_tickets_per_user
    if no_of_people.present? && no_of_people > 3
      errors.add(:no_of_people, "You can only register up to 3 people per event.")
    end
  end

  # Ensure event has enough capacity left
  def event_should_have_enough_capacity
    if event.present? && (event.current_participants + no_of_people) > event.max_participants
      errors.add(:base, "Not enough available seats for this event.")
    end
  end

  # Ensure event is still open (future date and correct status)
  def event_should_be_open_for_registration
    if event.present?
      if event.start_date < Date.today
        errors.add(:base, "Cannot register for an event that has already started.")
      end

      if event.status != "upcoming"
        errors.add(:base, "Registration is allowed only for upcoming events.")
      end
    end
  end

  # Prevent multiple confirmed registrations by the same user for the same event
  def unique_registration_per_user
    if EventRegistration.exists?(user_id: user_id, event_id: event_id, status: "Confirmed")
      errors.add(:base, "You have already registered for this event.")
    end
  end

  def apply_discount
      service = DiscountCalculatorService.new(self, discount_code)
      self.final_fee = service.calculate_final_fee
  end
end
