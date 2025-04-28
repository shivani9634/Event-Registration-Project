class EventRegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_event_registration, only: [ :show, :update ]
  before_action :authorize_request, except: [ :index, :show ]

  def create
    # Check if user has already registered for this event
    if EventRegistration.exists?(user_id: current_user.id, event_id: params[:event_registration][:event_id])
      render json: { error: "You have already registered for this event." }, status: :unprocessable_entity
      return
    end

    @event_registration = EventRegistration.new(event_registration_params)
    @event_registration.user = current_user
    @event_registration.registration_date = Time.current

    if @event_registration.no_of_people > 3
      render json: { error: "You can only book up to 3 tickets." }, status: :unprocessable_entity
      return
    end

    if @event_registration.save
      render json: { message: "Registration successful!" }, status: :ok
    else
      render json: { errors: @event_registration.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def index
    @registrations = EventRegistration.where(user_id: params[:user_id])
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
    params.require(:event_registration).permit(:event_id, :user_id, :id_proof, :discount_code_id, :final_fee, :registration_date, :status, :no_of_people)
  end
end
