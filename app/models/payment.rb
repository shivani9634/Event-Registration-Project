class Payment < ApplicationRecord
  belongs_to :event_registration, foreign_key: :registrartion_id

  validates :amount, :payment_mode, :payment_date, :status, :transaction_id, presence: true
  validates :payment_mode, inclusion: { in: [ "Credit Card", "Debit Card", "UPI", "Net Banking" ] }
  validates :status, inclusion: { in: [ "Pending", "Success", "Failed" ] }
end
