class CreateEventRegistrations < ActiveRecord::Migration[8.0]
  def change
    create_table :event_registrations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :discount_code, foreign_key: true
      t.string :id_proof, null: false
      t.decimal :final_fee, precision: 8, scale: 2, null: false
      t.datetime :registration_date, null: false
      t.string :status, null: false
      t.integer :no_of_people, null: false
      t.timestamps
    end
  end
end
