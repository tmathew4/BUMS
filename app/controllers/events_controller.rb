class EventsController < ApplicationController
  before_action :require_permission, only: [:destroy]
  
  def event_params
    params.require(:event).permit(:name, :date, :description, :ingredients, :minPartySize, :curPartySize, :maxPartySize, :recipes, :location, :image, :user_id, ethnicity: [:African, :American, :Asian, :French, :Indian, :Italian, :Latin_american, :Mediterranean, :Middle_eastern, :Spanish, :NA], dietary_restrictions: [:Gluten_free, :Nut_free , :Vegetarian, :Vegan,  :Paleo, :Keto, :Kosher, :NA] , category: [:Potluck, :Restaurant, :Breakfast, :Brunch, :Lunch, :Dinner, :All_day, :Other])
  end
  
  def require_permission
    if current_user.nil? or current_user.id != Event.find(params[:id]).user_id
      redirect_to events_path and return
    end
  end
  
  def isOwner
    return true if !current_user.nil? and current_user.id == Event.find(params[:id]).user_id
  end
  helper_method :isOwner
  
  def show
    id = params[:id]
    @event = Event.find(id)
    @owner = User.find_by_id(@event.user_id)
    
    @attendee = 'default'
    @attend_text = 'Attend Event?'
    @nevermind_text = 'Nevermind?'
    @user = User.find_by_id(session[:user_id])
    if not @user.nil? and @event.users.include? @user
        @attend_class, @attend_text = 'hidden', 'hidden'
        @attendee = @event.attendees.find_by_user_id(@user.id)
      else
        @nevermind_class, @nevermind_text = 'hidden', 'hidden'
    end
    
  end

  def index
    @sort_options = Event.sort_options
    
    #load defaults into session
    session[:start] = '' unless session.has_key?  :start
    session[:end]   = '' unless session.has_key?  :end
    session[:sort]  = ['date'] unless session.has_key? :sort
    
    @start  = params[:start] || session[:start]
    @end    = params[:end]   || session[:end]
    @sort   = params[:sort]  || session[:sort]
    @search = params[:search]
    
    @sort  = @sort.keys unless @sort.class == Array
    
    if not @search.blank?
      @events = Event.search_by_name @search
      @title = "Search Results"
    elsif @start.blank? or @end.blank?
      @events = Event.all
      @title = "All Events"
    else
      @events = Event.where(:date => @start.to_time..@end.to_time)
      @title = "All Events"
    end
    
    @sort.each do |option|
      @events = @events.order(option.to_sym) unless @events.nil? or @events.class == Array
    end
    
    @events = @events.to_a
    
    # Save session settings
    session[:start] = @start
    session[:end]   = @end
    session[:sort]  = @sort
  end

  def new
    @ethnicity_options = Event.ethnicity_options
    @dietary_restrictions_options = Event.dietary_restrictions_options
    @category_options = Event.category_options
  end

  def create
    @event = Event.create!(event_params)
    @event.update_attributes({:user_id => session[:user_id]})
    
    flash[:notice] = "#{@event.name} was successfully created."
    redirect_to events_path
  end

  def edit
    @ethnicity_options = Event.ethnicity_options
    @dietary_restrictions_options = Event.dietary_restrictions_options
    @category_options = Event.category_options

    id = params[:id]
    @event = Event.find(id)
    @ethnicities = @event.ethnicity.keys
    @dietary_restrictions = @event.dietary_restrictions.keys
    @categories = @event.category.keys
  end

  def update
    @event = Event.find params[:id]
    
    @event.update_attributes!(event_params)
    
    flash[:notice] = "#{@event.name} was successfully updated."
    redirect_to events_path
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = "Event '#{@event.name}' deleted"
    redirect_to events_path
  end

end
