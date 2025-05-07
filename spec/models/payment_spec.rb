# spec/models/payment_spec.rb

require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:user) { User.create!(name: "Test", surname: "User", email_id: "test@example.com", password: "password123", phone_number: 1234567890, role: Role.create!(role_type: "Attendee")) }
  let(:event) { Event.create!(organizer: user, category: Category.create!(name: "Tech"), name: "TechFest", description: "Technology Festival", venue: "Main Hall", start_date: Date.today + 10, end_date: Date.today + 11, max_participants: 200, id_proof_required: false, early_bird_cost: 50, base_cost: 100, early_bird_end_date: Date.today + 5, status: "upcoming", current_participants: 0) }
  let(:event_registration) do
    reg = EventRegistration.new(
      user: user,
      event: event,
      registration_date: Date.today,
      status: "confirmed",
      no_of_people: 1
    )
    reg.id_proof.attach(
      fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'id_proof.pdf'), 'application/pdf')
    )
    reg.save! # Will now pass with attached file
    reg
  end

  subject {
    described_class.new(
      event_registration: event_registration,
      amount: 500.00,
      payment_mode: "Credit Card",
      payment_date: Date.today,
      status: "confirmed",
      transaction_id: "TXN123456"
    )
  }

  describe "Associations" do
    it { should belong_to(:event_registration) }
  end

  describe "Validations" do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }

    it { should validate_presence_of(:payment_mode) }
    it { should validate_presence_of(:payment_date) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:transaction_id) }
    it { should validate_uniqueness_of(:transaction_id) }
  end
end
