class AddForeignKeyToEventRegistrations < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :event_registrations, :discount_codes if foreign_key_exists?(:event_registrations, :discount_codes)

    # Add the foreign key with on_delete: :cascade
    add_foreign_key :event_registrations, :discount_codes, on_delete: :cascade
  end
end
