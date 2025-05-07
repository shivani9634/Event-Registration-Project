# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  role_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ApplicationRecord
  has_many :users

  validates :role_type, presence: true
end
