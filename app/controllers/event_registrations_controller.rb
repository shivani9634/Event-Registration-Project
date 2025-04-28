class EventRegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_event_registration, only: [ :update ]
  before_action :authorize_request, except: [ :index, :show, :create ]

  def create
    @event_registration = EventRegistration.new(registration_params)
    @event_registration.registration_date = Time.current

    # Check if the discount code is present and apply the discount
    if @event_registration.discount_code.present?
      discount_calculator = DiscountCalculatorService.new(@event_registration, @event_registration.discount_code)
      @event_registration.final_fee = discount_calculator.calculate_final_fee
    else
      @event_registration.final_fee = @event_registration.event.base_cost
    end

    # Save the registration
    if @event_registration.save
      render json: { message: "Registration successful!" }, status: :ok
    else
      render json: { errors: @event_registration.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @registrations = EventRegistration.all
    render json: @registrations
  end

  def show
    render json: @registration
  end

  def update
    if @registration.update(registration_params)
      render json: @registration
    else
      render json: @registration.errors, status: :unprocessable_entity
    end
  end

  private

  def set_event_registration
    @registration = EventRegistration.find(params[:id])
  end

  def registration_params
    params.require(:event_registration).permit(:event_id, :user_id, :id_proof, :discount_code_id, :status, :registration_date, :no_of_people)
  end
end
