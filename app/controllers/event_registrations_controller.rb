class EventRegistrationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_event_registration, only: [ :show, :update ]

  def create
    @registration = EventRegistration.new(registration_params)

    if params[:event_registration][:discount_code].present?
      @registration.discount_code = DiscountCode.find_by(id: params[:event_registration][:discount_code].to_i)
    end

    if @registration.save
      render json: @registration, status: :created
    else
      render json: @registration.errors, status: :unprocessable_entity
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
