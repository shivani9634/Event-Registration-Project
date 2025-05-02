class PaymentsController < ApplicationController
  before_action :authorize_request
  load_and_authorize_resource

  def index
    @payments = Payment.all
    render json: @payments
  end

  def show
    @payment = Payment.find(params[:id])
    authorize! :read, @payment
    render json: @payment
  end

  def create
    @payment = Payment.new(payment_params)
    authorize! :create, @payment

    if @payment.save
      render json: { message: "Payment initiated successfully.", payment: @payment }, status: :created
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def success
    @payment = Payment.find_by(transaction_id: params[:transaction_id])
    authorize! :update, @payment

    if @payment.update(status: "Success", payment_date: Date.today)
      # Step 1: Get the event registration
      event_registration = @payment.event_registration

      if event_registration.present?
        event = event_registration.event

        if event.present?
          # Step 2: Increment current_participants by no_of_people
          event.current_participants ||= 0 # In case it's nil
          event.current_participants += event_registration.no_of_people || 0
          event.save
        end
      end

      render json: { message: "Payment marked as successful." }, status: :ok
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def failure
    @payment = Payment.find_by(transaction_id: params[:transaction_id])
    authorize! :update, @payment

    if @payment.update(status: "Failure", payment_date: Date.today)
      render json: { message: "Payment marked as failed." }, status: :ok
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @payment = Payment.find(params[:id])
    authorize! :update, @payment

    if @payment.update(payment_params)
      render json: { message: "Payment updated successfully.", payment: @payment }, status: :ok
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def payment_params
    params.require(:payment).permit(:event_registration_id, :amount, :payment_mode, :payment_date, :status, :transaction_id)
  end
end
