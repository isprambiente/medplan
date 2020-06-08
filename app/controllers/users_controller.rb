# frozen_string_literal: true

# This controller manage the views refering to {Risk} model
# * before_action :{powered_in!}
# * before_action :set_user, except: [:index, :list, :new, :create]
class UsersController < ApplicationController
  include Pagy::Backend
  before_action :powered_in!
  before_action :set_user, except: %i[index list new create]

  # GET /users
  #
  # render the list the all {User}
  # * set @users_filtered with {users}
  # * set @pagy, @user for the @users pagination
  # @return [Object] render users/index
  def index
    # index
  end

  # GET /users/list
  #
  # render the list the all {User}
  # * set @users_filtered with {users}
  # * set @pagy, @user for the @users pagination
  # @return [Object] render users/index
  def list
    @pagy, @users = pagy(users, link_extra: "data-remote='true' data-action='ajax:success->section#goPage'")
  end

  # GET /users/:id
  #
  # render the user details
  # * set @user with {set_user} method
  # * set @analisys with user's analisy events ({Event})
  # * set @visits with user's  visit events ({Event})
  # * set @audit with user's audits ({Audit})
  # @return [Object] render users/show
  def show
    @analisys = @user.events.analisys.future.to_a.uniq(&:id)
    @visits   = @user.events.visit.future.to_a.uniq(&:id)
    @audits   = @user.audits
  end

  # DELETE /users/:id
  #
  # set an {User} as locked
  # * set @user with {set_user} method
  # * use {User.disable!} method for lock the {User}
  # @return [Object] redirect to /home/index
  def destroy
    current_user = @user
    @user = User.unscoped.find(current_user.id) if @user.disable!
    redirect_to home_index_path(filter: { riepilogo: 'expired' })
  end

  # PATCH /users/:id/unlock
  #
  # Set an {User} as unlock
  # * set @user with {set_user} method
  # * use {User.enable!} method for unlock the {User}
  # render /users/show
  def unlock
    @user.enable!
    render @user
  end

  # PATCH /users/:id
  #
  # try to update an {User}
  # * set @user with {set_user} method
  # * set @response true if @user is updated
  # @return [Object] render users/index if @response is true otherwise render users/edit
  def update
    @response = @user.update(user_params)
    if @response
      render :show
    else
      render :edit
    end
  end

  # PUT /user/:id/notify
  #
  # Send notify for the user's analisy events and user's vitis events
  # @return [Nil]
  def notify
    return if @user.email.blank?

    Notifier.user_event_analisys(@user).deliver_now if @user.events.future.analisys.present?
    Notifier.user_event_visit(@user).deliver_now if @user.events.future.visit.present?
  end

  # GET /users/new
  #
  # render the form for make a new {User}
  # * set @user as new {User}
  # @return [Object] render /users/new
  def new
    @user = User.new
  end

  # GET /user/:id/edit_external
  #
  # render the form for make an external user
  # @return  [Object] render /users/new
  def edit_external_user
    render partial: 'form'
  end

  # GET
  def external_user
    if request.post?
      create
    elsif request.put?
      @user.label = "#{external_user_params[:lastname]} #{external_user_params[:name]}"
      if @user.update(external_user_params)
        redirect_to users_url
      else
        render :edit_external_user
      end
    end
  end

  # POST /users
  #
  # Add a new user manually
  def create
    @user = User.new(external_user_params)
    @user.label = "#{external_user_params[:lastname]} #{external_user_params[:name]}"
    if @user.save
      @users = User.where('label ilike ?', "%#{@user.label}%").order('label asc')
      @pagy, @users = pagy(@users, link_extra: "data-remote='true' data-action='ajax:success->users#goPage'")
      redirect_to users_url
    else
      render :new
    end
  end

  # render a single user
  def user
    render @user
  end

  # DELETE /user/remove_attachment
  #
  # delete the assegnazione file from user
  # @return [Object] render /users/show
  def remove_attachment
    @user.assegnazione.purge if @user.assegnazione.attached?
    render :show
  end

  private

  # imposta @user
  def set_user
    @user = User.unscoped.find(params[:id])
  end

  def user_params
    params.fetch(:user, {}).permit(:body, :tel, :assegnazione)
  end

  def external_user_params
    params.fetch(:user, {}).permit(:lastname, :name, :cf, :city, :sex, :email, :body, :tel, :assegnazione)
  end

  def filter_params
    params.fetch(:filter, {}).permit(:text, :invisible, :city, :category, :postazione)
  end

  def users
    @text = ['label ilike ?', "%#{filter_params[:text]}%"] if filter_params[:text].present?
    search = {}
    search[:city] = filter_params[:city] if filter_params[:city].present?
    search[:categories] = { id: filter_params[:category] } if filter_params[:category].present?
    search[:postazione] = filter_params[:postazione] if filter_params[:postazione].present?
    scope = filter_params[:invisible] == true ? :unscoped : :all

    User.send(scope).left_outer_joins(:categories).distinct.where(@text).where(search).order('label asc')
  end
end
