class CreateLocationDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :location_details do |t|
      t.text :address, null: false
      t.string :location_type, null: false
      t.timestamps
    end
  end
end
