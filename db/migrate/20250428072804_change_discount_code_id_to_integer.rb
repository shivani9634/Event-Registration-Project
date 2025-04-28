class ChangeDiscountCodeIdToInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :event_registrations, :discount_code_id, :integer
  end
end
