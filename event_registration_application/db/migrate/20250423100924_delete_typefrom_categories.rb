class DeleteTypefromCategories < ActiveRecord::Migration[8.0]
  def change
    remove_column :categories, :type, :string
  end
end
