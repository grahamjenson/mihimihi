class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all.select{|x| x.years_ago != nil && x.years_ago > 0}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

end
