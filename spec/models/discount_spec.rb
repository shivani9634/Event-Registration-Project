require 'rails_helper'

RSpec.describe DiscountCode, type: :model do
  let(:user) { User.create!(name: "Shivani", surname: "Poonia", email_id: "shivani@example.com", password: "password123", phone_number: 1234567890, role: Role.create!(role_type: "Organizer")) }
  let(:event) { Event.create!(organizer: user, category: Category.create!(name: "Tech"), name: "RubyConf", description: "Conference", venue: "Hall", start_date: Date.tomorrow + 5, end_date: Date.tomorrow + 6, max_participants: 100, id_proof_required: true, early_bird_cost: 50, base_cost: 100, early_bird_end_date: Date.today, status: "upcoming", current_participants: 0) }

  subject {
    described_class.new(
      event: event,
      user: user,
      discount_code: "SAVE20",
      discount_type: "percentage",
      discount_value: 20,
      valid_from: Date.today,
      valid_until: Date.today + 2,
      max_uses: 10,
      current_uses: 0,
      is_active: true
    )
  }

  describe "Associations" do
    it { should belong_to(:event) }
    it { should belong_to(:user) }
  end

  describe "Validations" do
    it { should validate_presence_of(:event_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:discount_code) }
    it { should validate_uniqueness_of(:discount_code) }
    it { should validate_length_of(:discount_code).is_at_least(3).is_at_most(30) }
    it { should validate_inclusion_of(:discount_type).in_array([ "percentage", "fixed" ]) }
    it { should validate_numericality_of(:discount_value).is_greater_than(0) }
    it { should validate_presence_of(:valid_from) }
    it { should validate_presence_of(:valid_until) }
    it { should validate_numericality_of(:max_uses).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:current_uses).only_integer.is_greater_than_or_equal_to(0) }
    it { should allow_value(true).for(:is_active) }
    it { should allow_value(false).for(:is_active) }

    context "custom validations" do
      it "is invalid if valid_until < valid_from" do
        subject.valid_until = subject.valid_from - 1
        expect(subject).not_to be_valid
        expect(subject.errors[:valid_until]).to include("must be after the valid from date")
      end

      it "is invalid if current_uses > max_uses" do
        subject.current_uses = 11
        expect(subject).not_to be_valid
        expect(subject.errors[:current_uses]).to include("cannot be greater than maximum allowed uses")
      end

      it "is invalid if percentage discount > 100" do
        subject.discount_value = 110
        expect(subject).not_to be_valid
        expect(subject.errors[:discount_value]).to include("must be between 1% and 100% for percentage type")
      end

      it "is invalid if fixed discount > 10000" do
        subject.discount_type = "fixed"
        subject.discount_value = 15000
        expect(subject).not_to be_valid
        expect(subject.errors[:discount_value]).to include("is too high for a fixed discount")
      end

      it "is invalid if valid_from is in the past" do
        subject.valid_from = Date.yesterday
        expect(subject).not_to be_valid
        expect(subject.errors[:valid_from]).to include("must be today or a future date")
      end

      it "is invalid if valid_until is in the past (on create)" do
        invalid_discount = subject.dup
        invalid_discount.valid_until = Date.yesterday
        expect(invalid_discount).not_to be_valid
        expect(invalid_discount.errors[:valid_until]).to include("cannot be a past date")
      end

      it "is invalid if validity period is less than 1 day" do
        subject.valid_until = subject.valid_from
        expect(subject).not_to be_valid
        expect(subject.errors[:valid_until]).to include("must be at least 1 day after the start date")
      end
    end
  end
end
