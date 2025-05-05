class AddForeignKeyEventToEventRegistrations < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :event_registrations, :events if foreign_key_exists?(:event_registrations, :events)

    # Add the foreign key with on_delete: :cascade
    add_foreign_key :event_registrations, :events, on_delete: :cascade
  end
end
