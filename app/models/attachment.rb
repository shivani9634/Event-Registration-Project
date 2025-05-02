class Attachment < ApplicationRecord
  belongs_to :event_registration

  has_one_attached :file # Using Active Storage
end
