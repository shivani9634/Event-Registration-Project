require 'rails_helper'

RSpec.describe User, type: :model do
  let(:role) { Role.create(role_type: "Organizer") }

  subject {
    described_class.new(
      name: "Shivani",
      surname: "Poonia",
      password: "password123",
      phone_number: 7817048110,
      email_id: "Shivani.poonia@joshsoftware.com",
      role: role
    )
  }

  context "Validations" do
    it "is valid with all attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a surname" do
      subject.surname = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a phone number" do
      subject.phone_number = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an email_id" do
      subject.email_id = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a role" do
      subject.role = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with a duplicate email_id" do
      subject.save
      duplicate_user = subject.dup
      duplicate_user.surname = "AnotherSurname"
      expect(duplicate_user).to_not be_valid
    end

    it "is not valid with invalid email format" do
      subject.email_id = "invalidemail"
      expect(subject).to_not be_valid
    end
  end

  context "Associations" do
    it { should belong_to(:role) }
    it { should have_many(:events).with_foreign_key('organizer_id') }
    it { should have_many(:discount_codes) }
  end

  context "Secure password" do
    it "authenticates with correct password" do
      user = subject
      user.save
      expect(user.authenticate("password123")).to eq(user)
    end

    it "does not authenticate with incorrect password" do
      user = subject
      user.save
      expect(user.authenticate("wrongpass")).to be_falsey
    end
  end
end
