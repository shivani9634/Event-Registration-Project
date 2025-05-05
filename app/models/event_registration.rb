# == Schema Information
#
# Table name: event_registrations
#
#  id                :integer          not null, primary key
#  event_id          :integer          not null
#  user_id           :integer          not null
#  discount_code_id  :integer
#  final_fee         :decimal(8, 2)    not null
#  registration_date :datetime         not null
#  status            :string           not null
#  no_of_people      :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_event_registrations_on_discount_code_id  (discount_code_id)
#  index_event_registrations_on_event_id          (event_id)
#  index_event_registrations_on_user_id           (user_id)
#

class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :discount_code, optional: true
  before_save :apply_discount
  has_one :payment, dependent: :destroy
  has_one_attached :id_proof, dependent: :destroy



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
