class User < ApplicationRecord
  has_secure_password
  belongs_to :role
  has_many :events, foreign_key: "organizer_id"
  has_many :discount_codes

  validates :name, :surname, :password, :phone_number, :email_id, presence: true
  validates :surname, uniqueness: true
  validates :email_id, format: { with: URI::MailTo::EMAIL_REGEXP }
end
