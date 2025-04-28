class DiscountCalculatorService
  def initialize(event_registration, discount_code = nil)
    @event_registration = event_registration
    @discount_code = discount_code
    @event = event_registration.event
    @no_of_people = event_registration.no_of_people # Capture the number of people for this registration
  end

  def calculate_final_fee
    return early_bird_fee if early_bird_applicable?

    # Apply discount only if early bird is not applicable
    return total_event_cost unless valid_discount_code?

    case @discount_code.discount_type
    when "percentage"
      apply_percentage_discount
    when "fixed"
      apply_fixed_discount
    else
      total_event_cost
    end
  end

  private

  def early_bird_applicable?
    # Check if today's date is before early_bird_end_date
    Date.today <= @event.early_bird_end_date
  end

  def early_bird_fee
    # If early bird is applicable, use the early bird cost
    @event.early_bird_cost * @no_of_people # Multiply early bird cost by the number of people
  end

  def valid_discount_code?
    @discount_code.present? && @discount_code.discount_value.present? && @discount_code.is_active? && within_valid_date_range?
  end

  def within_valid_date_range?
    current_date = Date.today
    @discount_code.valid_from <= current_date && @discount_code.valid_until >= current_date
  end

  def apply_percentage_discount
    discount = (@event.base_cost * @discount_code.discount_value) / 100.0
    total_discount = discount * @no_of_people # Apply discount for all people
    total_event_cost - total_discount
  end

  def apply_fixed_discount
    total_discount = @discount_code.discount_value * @no_of_people # Apply fixed discount for all people
    total_event_cost - total_discount
  end

  def total_event_cost
    # Calculate the total event cost for the number of people
    @event.base_cost * @no_of_people
  end
end
