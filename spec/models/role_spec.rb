require 'rails_helper'

RSpec.describe Role, type: :model do
  describe "Validations" do
    it "is valid with a role_type" do
      role = Role.new(role_type: "Organizer")
      expect(role).to be_valid
    end

    it "is invalid without a role_type" do
      role = Role.new(role_type: nil)
      expect(role).not_to be_valid
      expect(role.errors[:role_type]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "has many users" do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq(:has_many)
    end
  end
end
