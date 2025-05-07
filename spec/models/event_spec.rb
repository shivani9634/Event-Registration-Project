require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:organizer) { User.create!(name: "Ojasvi", surname: "khanna", email_id: "ojasvi.khanna@gmail.com", phone_number: 9988776655, password: "password", role: Role.create!(role_type: "organizer")) }
  let(:category)  { Category.create!(name: "Workshop") }

  subject {
    described_class.new(
      organizer: organizer,
      name: "RubyConf 2025",
      description: "A conference for Ruby developers.",
      venue: "Hall A",
      start_date: Date.tomorrow,
      end_date: Date.tomorrow + 2.days,
      max_participants: 100,
      id_proof_required: true,
      early_bird_cost: 50.00,
      early_bird_end_date: Date.tomorrow - 1.day,
      status: "upcoming",
      base_cost: 100.00,
      current_participants: 10,
      category: category
    )
  }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a name" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is invalid if name is not unique" do
      subject.save
      duplicate = subject.dup
      expect(duplicate).to_not be_valid
    end

    it "is invalid if end_date is before start_date" do
      subject.end_date = subject.start_date - 1.day
      expect(subject).to_not be_valid
      expect(subject.errors[:end_date]).to include("must be after the start date")
    end

    it "is invalid if current_participants exceeds max_participants" do
      subject.current_participants = 200
      expect(subject).to_not be_valid
    end

    it "is invalid if early_bird_end_date is on/after event start_date" do
      subject.early_bird_end_date = subject.start_date
      expect(subject).to_not be_valid
    end

    it "is invalid if early_bird_cost is greater than base_cost" do
      subject.early_bird_cost = 150.00
      expect(subject).to_not be_valid
    end

    it "is invalid if status is not in allowed list" do
      subject.status = "postponed"
      expect(subject).to_not be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:organizer).class_name('User') }
    it { should belong_to(:category) }
  end

  describe "Custom Validations" do
    it "does not allow overlapping events at the same venue" do
      subject.save!
      new_event = described_class.new(
        organizer: organizer,
        name: "Conflict Event",
        description: "Conflicting time",
        venue: "Hall A",
        start_date: subject.start_date + 1.day,
        end_date: subject.end_date,
        max_participants: 50,
        id_proof_required: false,
        early_bird_cost: 20.00,
        early_bird_end_date: subject.start_date - 1.day,
        status: "upcoming",
        base_cost: 80.00,
        current_participants: 5,
        category: category
      )
      expect(new_event).to_not be_valid
      expect(new_event.errors[:venue]).to include("has an existing event scheduled at the same time")
    end
  end
end
