class CreateDiscountCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :discount_codes do |t|
     t.references :event, null: false, foreign_key: true
     t.string :discount_code, null: false
     t.string :discount_type, null: false
     t.decimal :discount_value, precision: 8, scale: 2, null: false
     t.date :valid_from, null: false
     t.date :valid_until, null: false
     t.integer :max_uses, null: false
     t.integer :current_uses, null: false
     t.boolean :is_active, null: false
     t.references :user, null: false, foreign_key: true
     t.timestamps
    end
  end
end
