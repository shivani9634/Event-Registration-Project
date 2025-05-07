class RemoveColumnIdProofFromEventRegistrations < ActiveRecord::Migration[8.0]
  def change
    remove_column :event_registrations, :id_proof
  end
end
