# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  organizer_id         :integer          not null
#  name                 :string           not null
#  description          :text             not null
#  venue                :string           not null
#  start_date           :date             not null
#  end_date             :date             not null
#  max_participants     :integer          not null
#  id_proof_required    :boolean          not null
#  early_bird_cost      :decimal(8, 2)    not null
#  early_bird_end_date  :datetime         not null
#  status               :string           not null
#  base_cost            :decimal(8, 2)    not null
#  current_participants :integer          not null
#  category_id          :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_events_on_category_id   (category_id)
#  index_events_on_organizer_id  (organizer_id)
#

class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"
  belongs_to :category

  # Validations for attributes
  validates :organizer_id, presence: true
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :venue, presence: true, length: { minimum: 3, maximum: 150 }
  validates :start_date, presence: true, comparison: { greater_than_or_equal_to: Date.today, message: "must be in the future" }
  validates :end_date, presence: true
  validates :max_participants, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :id_proof_required, inclusion: { in: [ true, false ] }
  validates :early_bird_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :early_bird_end_date, presence: true
  validates :status, presence: true, inclusion: { in: %w[upcoming ongoing completed cancelled] }
  validates :base_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :current_participants, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category_id, presence: true

  validate :end_date_after_start_date
  validate :current_participants_within_limit
  validate :early_bird_end_date_before_event_start_date
  validate :max_participants_check
  validate :early_bird_cost_not_greater_than_base_cost
  validate :no_event_overlap_at_same_venue_and_time

  private

  # Custom validation method to ensure no overlapping events at the same venue
  def no_event_overlap_at_same_venue_and_time
    overlapping_event = Event.where(venue: venue)
                             .where.not(id: id)  # Exclude the current event (in case of update)
                             .where("start_date < ? AND end_date > ?", end_date, start_date)
                             .exists?

    if overlapping_event
      errors.add(:venue, "has an existing event scheduled at the same time")
    end
  end

  def end_date_after_start_date
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def current_participants_within_limit
    if current_participants > max_participants
      errors.add(:current_participants, "cannot exceed the maximum participants")
    end
  end

  def early_bird_end_date_before_event_start_date
    if early_bird_end_date.present? && start_date.present? && early_bird_end_date >= start_date
      errors.add(:early_bird_end_date, "must be before the event start date")
    end
  end

  def max_participants_check
    if current_participants > max_participants
      errors.add(:current_participants, "cannot exceed the maximum allowed participants")
    end
  end

  def early_bird_cost_not_greater_than_base_cost
    if early_bird_cost > base_cost
      errors.add(:early_bird_cost, "cannot be greater than base cost")
    end
  end
end
