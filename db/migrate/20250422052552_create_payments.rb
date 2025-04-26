class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :event_registration, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.string :payment_mode, null: false
      t.date :payment_date, null: false
      t.string :status, null: false
      t.string :transaction_id, null: false

      t.timestamps
    end
  end
end
