class DiscountCode < ApplicationRecord
  belongs_to :event
  belongs_to :user


  validates :discount_code, :discount_type, :discount_value, :valid_from, :valid_until, :max_uses, :current_uses, :is_active, presence: true

  validates :discount_type, inclusion: { in: [ "percentage", "flat" ] }
end
