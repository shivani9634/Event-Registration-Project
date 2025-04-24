class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :organizer, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.text :description, null: false
      t.string :venue, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :max_participants, null: false
      t.boolean :id_proof_required, null: false
      t.decimal :early_bird_cost, precision: 8, scale: 2, null: false
      t.datetime :early_bird_end_date, null: false
      t.string :status, null: false
      t.decimal :base_cost, precision: 8, scale: 2, null: false
      t.integer :current_participants, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
