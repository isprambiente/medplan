# frozen_string_literal: true

# This controller manage the views refering to {Event} model
# * before_action :{powered_in!}, except: :reserve
# * before_action :set_event, only: [:edit, :destroy, :confirmed, :confirmed_users]
# * before_action :set_user, only: [:new, :create, :reserve, :meeting_destroy, :meeting_sendmail, :confirmed]
# * before_action :set_meetings, only: [:reserve, :meeting_destroy, :meeting_sendmail]
class EventsController < ApplicationController
  before_action :powered_in!, except: %i[reserve]
  before_action :set_event, only: %i[edit destroy confirmed confirmed_users]
  before_action :set_user, only: %i[new create reserve meeting_destroy meeting_sendmail confirmed]
  before_action :set_meetings, only: %i[reserve meeting_destroy meeting_sendmail]

  # GET /events
  #
  # render events index
  # * set @meetings with all future events
  # @return [Object] render events/index
  def index
    @meetings = Event.future.where(id: Meeting.waiting.distinct(:event_id).pluck(:event_id))
  end

  # GET /events/agenda
  #
  # render a json with the events to popolate the calendari
  # * set @start date for the query from params[:start], if empty is set to beginning of the month
  # * set @stop  date for the query from params[:stop], if empty is set to end of month
  # * set @events with {Event.between}  param :start and param :stop
  # @return [Json] an array with @events for generate the calendar
  def agenda
    start = params[:start].presence || Time.zone.today.at_beginning_of_month
    stop = params[:end].presence || Time.zone.today.at_end_of_month
    @events = Event.between(start_on: start, stop_on: stop)
    render json: @events.map { |event| { id: "event-#{event.id}", title: "#{event.city} (#{event.meetings.confirmed.joins(:audit).group(:user_id).count.count}/#{event.users.distinct.count})", start: event.date_on, allDay: true, date_on: event.date_on, gender: event.gender, city: I18n.t(event.city, scope: 'user.cities', default: event.city), className: [event.gender.to_s], url: event_path(id: event.id) } }
  end

  # GET /events/new
  #
  # render
  def new
    @setdatevalue = ''
    @setdatevalue = params[:date] if params[:date].present?
    @event = Event.new
    @title = "Gestione eventi #{@user.label}"
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(@event.id)
    @meetings = @event.meetings.joins(:user).order('meetings.start_at asc, users.label asc').to_a.uniq { |a| a.user.id }
    @title = "#{t @event.gender, scope: 'event.genders'} #{@event.city.capitalize} del #{l @event.date_on}"
  end

  # POST /events
  # POST /events.json
  def create
    @current_event = Event.find_or_initialize_by(date_on: params[:event][:date_on].to_date, gender: Event.genders[params[:event][:gender]], city: params[:event][:city])
    if params[:event][:ids] != ['']
      @result = @current_event.update(event_params)
    else
      @result = false
      @message = t('select_one_category', scope: 'message.meeting').to_s
    end
    @event = @result ? Event.new : @current_event
    render :new
  end

  def reserve
    @event.user = @user
    old_status = @event.status(@user)
    @result = @event.update_status! if current_user.secretary? || (current_user == @user && @event.status(@user) == 'proposed')
    @meeting = @user.meetings.find_by(event: @event)
    @response = Notifier.user_event_confirmed(@user, @event).deliver_now if @result && current_user.secretary? && (@event.status(@user) != old_status)
    render partial: 'users/user_event', locals: { event: @event }
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    old_event = @event
    old_event.destroy
  end

  def meetings
    @meetings = Event.future.where(id: Meeting.waiting.distinct(:event_id).pluck(:event_id))
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def meeting_destroy
    @zone = params[:zone].presence || 'users'
    @meetings.destroy_all
    @destroyed = !Event.exists?(@event.id)
    if @zone == 'users' # && !@destroyed
      @event = Event.new
      render partial: 'new', status: :ok
    elsif @zone != 'users' && !@destroyed
      @meetings = @event.meetings.joins(:user).order('meetings.start_at asc, users.label asc').to_a.uniq { |a| a.user.id }
      render partial: 'edit', status: :ok
    end
  end

  def meeting_sendmail
    @zone = params[:zone].presence || 'users'
    Notifier.user_event(@user).deliver_now
    @meetings.update(sended_at: Time.zone.now)
  end

  def print
    @filter = params[:filter]
    @filename = @filter.blank? ? 'print.xlsx' : "#{@filter}.xlsx"
  end

  def confirmed
    @meeting = @user.meetings.find_by(event: @event)
    @meeting.sended_at = Time.zone.now
    if @meeting.save && @user.email.present?
      if @event.status(@user) == 'proposed'
        if @event.analisys?
          @response = Notifier.user_event_analisys(@user).deliver_now
        elsif @event.visit?
          @response = Notifier.user_event_visit(@user).deliver_now
        end
      else
        @response = Notifier.user_event_confirmed(@user, @event).deliver_now
      end
    end
    @zone = params[:zone].presence || 'users'
    if @zone == 'users'
      @event = Event.new
      render partial: 'new', status: :ok
    elsif @zone == 'events'
      render partial: 'events/meeting', locals: { meeting: @meeting }, status: :ok
    end
  end

  def confirmed_users
    @meetings = @event.meetings.joins(:user).order('meetings.start_at asc, users.label asc').to_a.uniq { |a| a.user.id }
    @meetings.each do |meeting|
      user = meeting.user
      response = user.email.blank? ? false : Notifier.user_event_confirmed(user, @event).deliver_now
      if response
        meeting.sended_at = Time.zone.now
        meeting.save
      end
    end
    head :ok
  end

  private

  # Set @event for many action. Event is set from params[:id]
  def set_event
    @event = Event.find(params[:id])
  end

  # set @event and @meetings for many action.
  def set_meetings
    @event = Event.find(params[:event_id])
    @meetings = @user.meetings.where(event: @event)
  end

  # Filter params for creeate end update {Event}
  def event_params
    params.fetch(:event, {}).permit(:date_on, :gender, :city, :start_at, :state, ids: [])
  end

  # Set @user form many action
  def set_user
    @user = User.find(params[:user_id])
  end
end
