# == Schema Information
#
# Table name: discount_codes
#
#  id             :integer          not null, primary key
#  event_id       :integer          not null
#  discount_code  :string           not null
#  discount_type  :string           not null
#  discount_value :decimal(8, 2)    not null
#  valid_from     :date             not null
#  valid_until    :date             not null
#  max_uses       :integer          not null
#  current_uses   :integer          not null
#  is_active      :boolean          not null
#  user_id        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_discount_codes_on_event_id  (event_id)
#  index_discount_codes_on_user_id   (user_id)
#

class DiscountCode < ApplicationRecord
  belongs_to :event
  belongs_to :user

  # Basic validations
  validates :event_id, presence: true
  validates :user_id, presence: true
  validates :discount_code, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :discount_type, presence: true, inclusion: { in: [ "percentage", "fixed" ], message: "%{value} is not a valid discount type" }
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :valid_from, presence: true
  validates :valid_until, presence: true
  validates :max_uses, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :current_uses, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :is_active, inclusion: { in: [ true, false ] }

  # Custom validations
  validate :validity_dates_check

  private

  def validity_dates_check
    if valid_from.present? && valid_until.present?
      if valid_until < valid_from
        errors.add(:valid_until, "must be after the valid from date")
      end
    end
  end

  validate :current_uses_not_exceed_max_uses

  def current_uses_not_exceed_max_uses
    if current_uses.present? && max_uses.present? && current_uses > max_uses
      errors.add(:current_uses, "cannot be greater than maximum allowed uses")
    end
  end

  validate :percentage_value_check

  def percentage_value_check
    if discount_type == "percentage" && discount_value.present?
      if discount_value <= 0 || discount_value > 100
        errors.add(:discount_value, "must be between 1% and 100% for percentage type")
      end
    end
  end

  validate :minimum_validity_period

  def minimum_validity_period
    if valid_from.present? && valid_until.present? && (valid_until - valid_from).to_i < 1
    errors.add(:valid_until, "must be at least 1 day after the start date")
    end
  end

  validate :valid_until_not_in_past, on: :create

  def valid_until_not_in_past
    if valid_until.present? && valid_until < Date.today
    errors.add(:valid_until, "cannot be a past date")
    end
  end

  validate :fixed_discount_upper_limit

  def fixed_discount_upper_limit
    if discount_type == "fixed" && discount_value.present? && discount_value > 10000
    errors.add(:discount_value, "is too high for a fixed discount")
    end
  end

  validate :valid_from_today_or_future

  def valid_from_today_or_future
    if valid_from.present? && valid_from < Date.today
    errors.add(:valid_from, "must be today or a future date")
    end
  end
end
