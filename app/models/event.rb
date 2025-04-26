class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"
  belongs_to :category
  has_many :event_registrations
  has_many :discount_codes

  validates :name, :description, :venue, :start_date, :end_date, :max_participants, :id_proof_required, :early_bird_cost, :early_bird_end_date, :status, :base_cost, :current_participants, presence: true
end
