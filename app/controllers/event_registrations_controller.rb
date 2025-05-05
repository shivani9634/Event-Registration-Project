class EventRegistrationsController < ApplicationController
  before_action :set_event_registration, only: [ :update, :destroy ]
  before_action :authorize_request

  load_and_authorize_resource

  def create
    @event_registration = EventRegistration.new(event_registration_params)
    @event_registration.registration_date = Time.current

    if @event_registration.discount_code.present?
      discount_calculator = DiscountCalculatorService.new(@event_registration, @event_registration.discount_code)
      @event_registration.final_fee = discount_calculator.calculate_final_fee
    else
      @event_registration.final_fee = @event_registration.event.base_cost
    end

    if @event_registration.save
      render json: { message: "Registration successful!", id_proof_url: url_for(@event_registration.id_proof) }, status: :ok
    else
      render json: { errors: @event_registration.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def index
    render json: @event_registrations
  end

  def show
    render json: @event_registration
  end

  def update
    if @event_registration.update(event_registration_params)
      render json: {
        registration: @event_registration,
        id_proof_url: url_for(@event_registration.id_proof)
      }, status: :ok
    else
      render json: { errors: @event_registration.errors.full_messages }, status: :unprocessable_entity
    end
  end



  def destroy
    if @event_registration.destroy
      render json: { message: "Registration successfully deleted." }, status: :ok
    else
      render json: { errors: "Failed to delete registration." }, status: :unprocessable_entity
    end
  end

  private

  def set_event_registration
    @event_registration = EventRegistration.find(params[:id])
  end

  def event_registration_params
    params.require(:event_registration).permit(:event_id, :user_id, :discount_code_id, :status, :registration_date, :no_of_people, :id_proof)
  end
end
