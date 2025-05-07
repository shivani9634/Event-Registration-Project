require 'rails_helper'

RSpec.describe EventRegistration, type: :model do
  let(:role) { Role.create!(role_type: "Attendee") }
  let(:user) { User.create!(name: "Shivani", surname: "Poonia", email_id: "shivani@example.com", password: "password123", phone_number: 1234567890, role: role) }
  let(:category) { Category.create!(name: "Tech") }
  let(:event) {
    Event.create!(
      organizer: user,
      category: category,
      name: "RubyConf",
      description: "Tech conference",
      venue: "Auditorium",
      start_date: Date.tomorrow + 10.days,
      end_date: Date.tomorrow + 12.days,
      max_participants: 50,
      id_proof_required: true,
      early_bird_cost: 50,
      base_cost: 100,
      early_bird_end_date: Date.today,
      status: "upcoming",
      current_participants: 0
    )
  }

  let(:valid_attributes) do
    {
      user: user,
      event: event,
      final_fee: 100.00,
      registration_date: Time.now,
      status: "Pending",
      no_of_people: 1,
      id_proof: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'id_proof.pdf'), 'application/pdf')
    }
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      registration = EventRegistration.new(valid_attributes)
      expect(registration).to be_valid
    end

    it "is invalid with more than 3 people" do
      registration = EventRegistration.new(valid_attributes.merge(no_of_people: 4))
      expect(registration).not_to be_valid
      expect(registration.errors[:no_of_people]).to include("You can only register up to 3 people per event.")
    end

    it "is invalid without id_proof" do
      registration = EventRegistration.new(valid_attributes.except(:id_proof))
      expect(registration).not_to be_valid
      expect(registration.errors[:id_proof]).to include("can't be blank")
    end

    it "is invalid when event has no more seats" do
      event.update!(current_participants: 48)
      registration = EventRegistration.new(valid_attributes.merge(no_of_people: 3))
      expect(registration).not_to be_valid
      expect(registration.errors[:base]).to include("Not enough available seats for this event.")
    end

    it "is invalid when event is not 'upcoming'" do
      event.update!(status: "completed")
      registration = EventRegistration.new(valid_attributes)
      expect(registration).not_to be_valid
      expect(registration.errors[:base]).to include("Registration is allowed only for upcoming events.")
    end

    it "prevents duplicate confirmed registration" do
      EventRegistration.create!(valid_attributes.merge(status: "Confirmed"))
      registration2 = EventRegistration.new(valid_attributes.merge(status: "Confirmed"))
      expect(registration2).not_to be_valid
      expect(registration2.errors[:base]).to include("You have already registered for this event.")
    end
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:event) }
    it { should belong_to(:discount_code).optional }
    it { should have_one(:payment).dependent(:destroy) }
    it { should have_one_attached(:id_proof) }
  end

  describe "Callbacks" do
    it "applies discount before saving" do
      service = instance_double("DiscountCalculatorService")
      allow(DiscountCalculatorService).to receive(:new).and_return(service)
      allow(service).to receive(:calculate_final_fee).and_return(80.0)

      registration = EventRegistration.new(valid_attributes)
      registration.save!
      expect(registration.final_fee).to eq(80.0)
    end
  end
end
