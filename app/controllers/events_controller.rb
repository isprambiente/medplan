# frozen_string_literal: true

# This controller manage the views refering to {Event} model
# * before_action :{powered_in!}, except: :reserve
# * before_action :set_event, only: [:edit, :destroy, :confirmed, :confirmed_users]
# * before_action :set_user, only: [:new, :create, :reserve, :meeting_destroy, :meeting_sendmail, :confirmed]
# * before_action :set_meetings, only: [:reserve, :meeting_destroy, :meeting_sendmail]
class EventsController < ApplicationController
  before_action :powered_in!, except: %i[reserve]
  before_action :set_event, only: %i[edit meetings destroy confirmed confirmed_users]
  before_action :set_user, only: %i[new create reserve meeting_destroy meeting_sendmail confirmed]
  before_action :set_meetings, only: %i[reserve meeting_destroy meeting_sendmail]
  before_action :set_timer, except: %i[index agenda]
  before_action :set_view

  # GET /events
  #
  # render events index
  # @return [Object] render events/index
  def index; end

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
    render json: @events.map { |event| { id: "event-#{event.id}", title: "#{event.city} (#{event.meetings.confirmed.joins(:audit).group(:user_id).count.count}/#{event.users.distinct.count})", start: event.date_on, allDay: true, date_on: event.date_on, gender: event.gender, city: I18n.t(event.city, scope: 'user.cities', default: event.city), className: [event.gender.to_s], url: edit_event_path(id: event.id) } }
  end

  # GET /events/new
  #
  # render
  def new
    @setdatevalue = ''
    @setdatevalue = params[:date] if params[:date].present?
    @event = Event.new
    @title = "Gestione eventi #{@user.label}"
    set_timer
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(@event.id)
    @meetings = @event.meetings.joins(:user).order('meetings.start_at asc, users.label asc').to_a.uniq { |a| a.user.id }
    @title = "#{t @event.gender, scope: 'event.genders'} #{@event.city.capitalize} del #{l @event.date_on}"
    timer = []
    Settings.events.ranges.each do |range|
      timer += (range.start_time.in_time_zone.to_datetime.to_i .. range.end_time.in_time_zone.to_datetime.to_i).step(range.interval.minutes).map{|t| Time.zone.at(t).strftime('%H:%M') }
    end
    @timer = timer.uniq.sort
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
    @event = Event.new
    if @result
      set_timer
      flash.now[:success] = 'Creazione avvenuta con successo'
      render turbo_stream: [
        turbo_stream.replace(:flashes, partial: "flashes"),
        turbo_stream.replace("user_#{@user.id}_event_form", partial: "events/form", locals: {user: @user, event: @event, timer: @timer, view: @view}),
        turbo_stream.update("user_#{@user.id}_events", partial: "events/events", locals: {user: @user}),
        turbo_stream.update("user_#{@user.id}", partial: "users/user", locals: {user: @user})
      ]
    else
      set_timer
      flash.now[:error] = @message
      render turbo_stream: [
        turbo_stream.replace(:flashes, partial: "flashes"),
        turbo_stream.replace("user_#{@user.id}_event_form", partial: "events/form", locals: {user: @user, event: @event, timer: @timer, view: @view})
      ]
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def reserve
    @template = params[:template].presence || 'user'
    @event.user = @user
    old_status = @event.status(@user)
    @result = @event.update_status! if current_user.secretary? || (current_user == @user && @event.status(@user) == 'proposed')
    @meeting = @user.meetings.find_by(event: @event)
    if @template == 'user'
      render partial: 'home/user_event', locals: { meeting: @meeting, event: @event, user: @user }
    else
      if @template == 'secretary'
        set_timer
        render turbo_stream: [
          turbo_stream.replace("user_#{@user.id}", partial: 'users/user', locals: { meeting: @meeting, event: @event, user: @user, timer: @timer }),
          turbo_stream.replace("user_#{@user.id}_event_#{@event.id}", partial: 'users/user_event', locals: { event: @event, user: @user })
        ]
      else
        render turbo_stream: [
          turbo_stream.replace("event_#{@event.id}", partial: 'events/edit', locals: { meeting: @meeting, event: @event, user: @user, view: @view }),
          turbo_stream.update('yield', partial: "events/index")
        ]
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    old_event = @event
    old_event.destroy
    flash.now[:success] = 'Cancellazione avvenuta con successo'
    render turbo_stream: [
      turbo_stream.replace(:flashes, partial: "flashes", locals: {force: 'true'}),
      turbo_stream.update('yield', partial: "events/index")
    ]
  end

  # GET /events/1/meetings
  def meetings
    @meetings = @event.meetings.joins(:user).order('meetings.start_at asc, users.label asc').to_a.uniq { |a| a.user.id }
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def meeting_destroy
    @zone = params[:zone].presence || 'users'
    @meetings.destroy_all
    @destroyed = !Event.exists?(@event.id)
    if @zone == 'users' # && !@destroyed
      @event = Event.new
      flash.now[:success] = 'Cancellazione avvenuta con successo'
    elsif @zone != 'users' && !@destroyed
      flash.now[:success] = 'Modifica avvenuta con successo'
    end
    render turbo_stream: [
      turbo_stream.replace(:flashes, partial: "flashes"),
      turbo_stream.update("user_#{@user.id}_events", partial: "events/events", locals: {user: @user}),
      turbo_stream.update("user_#{@user.id}", partial: "users/user", locals: {user: @user}),
      turbo_stream.update("event_#{@event.id}_meetings", partial: 'events/meeting', collection: @event.meetings.joins(:user).order('meetings.start_at asc, users.label asc').to_a.uniq { |a| a.user.id }, as: :meeting, locals: {event: @event}),
    ]
  end

  # PUT /events/1/meetings/sendmail
  def meeting_sendmail
    @zone = params[:zone].presence || 'users'
    if @event.analisys?
      Notifier.user_event_analisys(@user, @event).deliver_now
    elsif @event.visit?
      Notifier.user_event_visit(@user, @event).deliver_now
    end
    @meetings.update(sended_at: Time.zone.now)
  end

  # GET /events/1/print
  def print
    @filter = params[:filter]
    @filename = @filter.blank? ? 'print.xlsx' : "#{@filter}.xlsx"
  end

  # PUT /events/1/confirmed
  def confirmed
    @meeting = @user.meetings.find_by(event: @event)
    @meeting.sended_at = Time.zone.now
    if @meeting.save && @user.email.present?
      if @event.analisys?
        @response = Notifier.user_event_analisys(@user, @event).deliver_now
      elsif @event.visit?
        @response = Notifier.user_event_visit(@user, @event).deliver_now
      end
    end
    @zone = params[:zone].presence || 'users'
    if @zone == 'users'
      @event = Event.new
      set_timer
      render partial: 'new', locals: { meeting: @meeting, event: @event, user: @user, view: @view, timer: @timer }, status: :ok
    elsif @zone == 'events'
      flash.now[:success] = 'Notifica inviata con successo'
      respond_to do |format|
        format.html do
          render partial: 'events/meeting', locals: { meeting: @meeting, event: @event, user: @user, timer: @timer }, status: :ok
        end
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("meeting_#{@meeting.id}", partial: 'events/meeting', locals: { meeting: @meeting, event: @event, user: @user }),
            turbo_stream.replace("event_#{@event.id}_summary", partial: 'events/summary', locals: { meeting: @meeting, event: @event, user: @user }),
            turbo_stream.update('yield', partial: "events/index")
          ]
        end
      end
    end
  end

  # PUT /events/1/confirmed_users
  def confirmed_users
    @meetings = @event.meetings.joins(:user).order('meetings.start_at asc, users.label asc').to_a.uniq { |a| a.user.id }
    @meetings.each do |meeting|
      response = false
      user = meeting.user

      if @event.analisys?
        response = Notifier.user_event_analisys(user, @event).deliver_now
      elsif @event.visit?
        response = Notifier.user_event_visit(user, @event).deliver_now
      end

      if response
        meeting.sended_at = Time.zone.now
        meeting.save
      end
    end
    render turbo_stream: [
      turbo_stream.replace("event_#{@event.id}", partial: 'events/edit', locals: { meeting: @meeting, event: @event, user: @user, view: @view }),
    ]
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

  # Set callback view
  def set_view
    @view = filter_params[:view] || ''
  end

  # Only allow a list of trusted parameters through.
  def filter_params
    params.fetch(:filter, {}).permit(:view)
  end

  # Set @timer into form
  def set_timer
    timer = []
    Settings.events.ranges.each do |range|
      timer += (range.start_time.in_time_zone.to_datetime.to_i .. range.end_time.in_time_zone.to_datetime.to_i).step(range.interval.minutes).map{|t| Time.zone.at(t).strftime('%H:%M') }
    end
    @timer = timer.uniq.sort
  end
end
