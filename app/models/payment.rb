# == Schema Information
#
# Table name: payments
#
#  id                    :integer          not null, primary key
#  event_registration_id :integer          not null
#  amount                :decimal(8, 2)    not null
#  payment_mode          :string           not null
#  payment_date          :date             not null
#  status                :string           not null
#  transaction_id        :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_payments_on_event_registration_id  (event_registration_id)
#

class Payment < ApplicationRecord
  belongs_to :event_registration

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_mode, presence: true
  validates :payment_date, presence: true
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled] }
  validates :transaction_id, presence: true, uniqueness: true
end
