class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :password, null: false
      t.bigint :phone_number, null: false
      t.string :email_id, null: false
      t.references :role,  foreign_key: true
      t.timestamps
    end
  end
end
