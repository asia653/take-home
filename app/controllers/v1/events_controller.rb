class V1::EventsController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]
  
  def create
    @event = @current_user.events.new(event_params)
    if @event.save
      render status: 200
    else 
      render json: { message: "there was an issue creating the event", errors: @event.errors}, status: 400
    end
  end

  def index
    @events = Event.all
  end

  def show 
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    authorize @event
    if @event.update(event_params)
      render status: 200
    else
      render json: { message: "there was an issue updating the event", errors: @event.errors}, status: 400
    end
  end

  def destroy
    @event = Event.find(params[:id])
    authorize @event
    @event.destroy
    render status: 200
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :start_time, :end_time)
  end
end
