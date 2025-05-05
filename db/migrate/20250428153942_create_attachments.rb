class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :event_registration, null: false, foreign_key: true

      t.timestamps
    end
  end
end
