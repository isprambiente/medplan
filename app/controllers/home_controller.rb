# frozen_string_literal: true

# This controller manage some index views for specific users type
# * before_action :home_redirect, except: [:user] -> {home_redirect}
# * before_action :doctor_in!, only: [:report] -> {doctor_in!}
class HomeController < ApplicationController
  include Pagy::Backend
  before_action :home_redirect, except: [:user, :reset_password]
  before_action :doctor_in!, only: [:report]
  before_action :set_view

  # GET /
  # GET /home/index
  #
  # Is application's root index. The access is granted onl for doctor, secretary an admin,
  # other user are redirect to {user} (GET /home/user)
  #
  # * preset @users with all {User}
  # @return [Object] render /home/index
  def index
    @riepilogo ||= 'expired'
    @expire = ''
    @users = User.all.unsystem.left_outer_joins(:categories).distinct
    @start_at = Time.zone.today.at_beginning_of_month
    @stop_at = Time.zone.today.end_of_month
    @next_start_at = Time.zone.today.at_beginning_of_month.next_month
    @next_stop_at = Time.zone.today.end_of_month.next_month
    @next_2_start_at = (Time.zone.today + 2.months).at_beginning_of_month
    @next_2_stop_at = (Time.zone.today + 2.months).end_of_month.next_month
  end

  # GET /home/index
  #
  # List users with pagination and filers
  #
  # * preset @user with {users}
  # * set @pagy, @users for the {User} pagination
  # @return [Object] render partial /home/_index
  def list
    users
    flash.now[:success] = 'Caricamento completato'
  end

  # GET /home/meetings
  #
  # List meetings with pagination
  #
  # * set @meetings searching the future {Meeting}
  # @return [Object] render partial /home/_meetings
  def meetings
    @meetings = Event.future.where(id: Meeting.waiting.distinct(:event_id).pluck(:event_id))
    # render partial: 'meetings', collection: @meetings, as: :event
  end

  # GET /home/user
  #
  # Is standard user home page, show the future events and the user status for each category risk
  # * set @user with current_user
  # * set @analisys with the future analisy events
  # * set @visits with the future visit events
  # @return [Object] render /home/user
  def user
    @user = current_user
    @analisys = @user.events.analisys.future
    @visits = @user.events.visit.future
    respond_to :html, :json
  end

  # GET /home/report
  #
  # Is an excel report available only for doctors
  # * set @year with params[:report][:year]
  # * set @range as 0
  # * set @city with params[:report][:city]
  # * set @start_at, @stop_at with {get_dates_range}
  # * set @users from the history
  # @return {Object} render /home/report
  def report
    return if params[:report].blank?

    @year = params[:report][:year].presence || Time.zone.today.year
    @range = 0
    @city = params[:report][:city].presence || :roma
    get_dates_range(@range, @year)
    @users = History.unscoped.joins(:user, :risk).where('users.city=?', User.cities[@city])
    @filename = @city.blank? ? 'report-medicina.xlsx' : "#{@city}-#{@year}.xlsx"
    respond_to do |format|
      format.js
      format.xlsx
    end
  end

  # PUT /home/reset_password
  #
  # Is function for change the user password
  # * set @user as current_user
  # @return {Object} render /home/new_password
  def reset_password
    status = :ok
    @user = current_user
    if user_params[:password] != user_params[:password_confirmation]
      @user.errors.add(:password, 'Not valid')
      @user.errors.add(:current_password, 'Not valid')
    else
      @user.password = user_params[:password]
      if @user.save
        flash.now[:success] = 'Modifica avvenuta con successo'
      else
        status = 500
        flash.now[:error] = 'Si è verificato un errore durante la modifica'
      end
    end
    redirect_to new_user_session_path
  end

  private

  def get_dates_range(range, year)
    case range.to_i
    when 0
      @start_at = "01/01/#{year}".to_date
      @stop_at = "31/12/#{year}".to_date
    when 1
      @start_at = "01/01/#{year}".to_date
      @stop_at = "30/06/#{year}".to_date
    when 2
      @start_at = "01/07/#{year}".to_date
      @stop_at = "31/12/#{year}".to_date
    end
  end

  def home_redirect
    redirect_to home_user_path unless current_user.doctor? || current_user.secretary?
  end

  def user_params
    params.fetch(:user, {}).permit(:password, :current_password, :password_confirmation)
  end

  def filter_params
    params.fetch(:filter, {}).permit(:riepilogo, :city, :postazione, :text, :view)
  end

  # Set callback view
  def set_view
    @view = filter_params[:view] || ''
  end

  def users
    @filters = filter_params
    selected = {}
    selected[:city] = @filters[:city] if @filters[:city].present?
    selected[:postazione] = @filters[:postazione] if @filters[:postazione].present?

    @text = ['label ilike ?', "%#{@filters[:text]}%"] if @filters[:text].present?
    @postazione = @filters[:postazione]
    @city = @filters[:city].try(:to_i)
    @riepilogo = @filters[:riepilogo] || 'expired'
    @page = params[:page] || 1

    @start_at = Time.zone.today.at_beginning_of_month
    @stop_at = Time.zone.today.end_of_month
    @next_start_at = Time.zone.today.at_beginning_of_month.next_month
    @next_stop_at = Time.zone.today.end_of_month.next_month
    @next_2_start_at = (Time.zone.today + 2.months).at_beginning_of_month
    @next_2_stop_at = (Time.zone.today + 2.months).end_of_month.next_month
    filter, scope = case @riepilogo
                    when 'new' then [nil, :unassigned]
                    when 'expired' then [['audits.expire < ? ', @start_at], :syncable]
                    when 'nextmonth' then [['audits.expire Between ? And ?', @next_start_at, @next_stop_at], :syncable]
                    when 'next2months' then [['audits.expire Between ? And ?', @next_2_start_at, @next_2_stop_at], :syncable]
                    when 'locked' then [nil, :locked]
                    when 'blocked' then [nil, :blocked]
                    else [['audits.expire Between ? And ?', @start_at, @stop_at], :syncable]
                    end
    users_list = User.unsystem.left_outer_joins(:categories) #.distinct
    users_list = if %w[locked blocked new].include?(@filters[:riepilogo])
                   users_list.send(scope).group('users.label, users.id')
                 else
                   users_list.send(scope).select('users.*, audits.expire').where(filter).group('audits.expire, users.label, users.id')
                 end
    order = unless %w[locked blocked new].include?(@filters[:riepilogo])
              'audits.expire, users.label'
            else
              'users.label'
            end
    users_list = users_list.where(selected).where(@text).reorder(order)
    @users_list = users_list
    @pagy, @users = pagy(users_list, page: @page, count: users_list.length, link_extra: "data-turbo-frame='users'")
  end
end
