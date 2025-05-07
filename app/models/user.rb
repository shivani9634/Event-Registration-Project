# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  surname         :string           not null
#  password_digest :string           not null
#  phone_number    :integer          not null
#  email_id        :string           not null
#  role_id         :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_role_id  (role_id)
#  index_users_on_surname  (surname) UNIQUE
#

class User < ApplicationRecord
  has_secure_password
  belongs_to :role
  has_many :events, foreign_key: "organizer_id"
  has_many :discount_codes

  validates :name, :surname, :password, :phone_number, :email_id, presence: true
  validates :role, presence: true
  validates :email_id, uniqueness: true
  validates :email_id, format: { with: URI::MailTo::EMAIL_REGEXP }
end
