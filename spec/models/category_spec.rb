require 'rails_helper'

RSpec.describe Category, type: :model do
  # Test valid category
  describe "Validations" do
    it "is valid with a unique name" do
      category = Category.new(name: "Tech")
      expect(category).to be_valid
    end

    # Test invalid category (duplicate name)
    it "is invalid with a duplicate name" do
      Category.create!(name: "Tech")
      category = Category.new(name: "Tech")
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("has already been taken")
    end

    # Test invalid category (missing name)
    it "is invalid without a name" do
      category = Category.new(name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end
  end
end
