class ChangeRoleTypeUserToAttendee < ActiveRecord::Migration[8.0]
  def change
    execute "UPDATE roles SET role_type = 'attendee' WHERE role_type = 'user';"
  end
end
