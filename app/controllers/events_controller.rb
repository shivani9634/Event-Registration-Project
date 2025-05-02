class EventsController < ApplicationController
  before_action :authorize_request, only: [ :create, :update, :destroy ]
  load_and_authorize_resource

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
    if @event.destroy
      render json: { message: "Event deleted successfully." }, status: :ok
    else
      render json: { errors: "Failed to delete event." }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:organizer_id, :name, :description, :venue, :start_date, :end_date, :max_participants, :id_proof_required, :early_bird_cost, :early_bird_end_date, :status, :base_cost, :current_participants, :category_id)
  end
end
