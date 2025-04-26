class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_event, only: [ :show, :update, :destroy ]

  def create
    @event = Event.new(event_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def index
    @events = Event.all
    render json: @events
  end

  def show
    render json: @event
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:organizer_id, :name, :description, :venue, :start_date, :end_date, :max_participants, :id_proof_required, :early_bird_cost, :early_bird_end_date, :status, :base_cost, :current_participants, :category_id)
  end
end
