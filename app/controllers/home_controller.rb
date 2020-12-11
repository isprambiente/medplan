# frozen_string_literal: true

# This controller manage some index views for specific users type
# * before_action :home_redirect, except: [:user] -> {home_redirect}
# * before_action :doctor_in!, only: [:report] -> {doctor_in!}
class HomeController < ApplicationController
  include Pagy::Backend
  before_action :home_redirect, except: [:user]
  before_action :doctor_in!, only: [:report]

  # GET /
  # GET /home/index
  #
  # Is application's root index. The access is granted onl for doctor, secretary an admin,
  # other user are redirect to {user} (GET /home/user)
  #
  # * preset @users with all {User}
  # @return [Object] render /home/index
  def index
    @expire = ''
    @users = User.all.left_outer_joins(:categories).distinct
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
  end

  # GET /home/meetings
  #
  # List meetings with pagination
  #
  # * set @meetings searching the future {Meeting}
  # @return [Object] render partial /home/_meetings
  def meetings
    @meetings = Event.future.where(id: Meeting.waiting.distinct(:event_id).pluck(:event_id))
    render partial: 'meetings', collection: @meetings, as: :event
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

    @year = params[:report][:year]
    @range = 0
    @city = params[:report][:city]
    get_dates_range(@range, @year)
    @users = History.unscoped.joins(:user, :risk).where('users.city=?', User.cities[@city])
    @filename = @city.blank? ? 'report-medicina.xlsx' : "#{@city}-#{@year}.xlsx"
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

  def filter_params
    params.fetch(:filter, {}).permit(:riepilogo, :city, :postazione)
  end

  def users
    @filters = filter_params
    selected = {}
    selected[:city] = @filters[:city] if @filters[:city].present?
    selected[:postazione] = @filters[:postazione] if @filters[:postazione].present?

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
    users_list = User.left_outer_joins(:categories) #.distinct
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
    users_list = users_list.where(selected).reorder(order)
    @pagy, @users = pagy(users_list, page: @page, count: users_list.length, link_extra: "data-remote='true' data-action='ajax:success->section#goPage'")
  end
end
