# frozen_string_literal: true

# This controller manage the views refering to {Audit} model
# * before_action :powered_in!
# * before_action :set_user
# * before_action set_audit, except: [:index, :create, :destroy]
class AuditsController < ApplicationController
  include Pagy::Backend
  before_action :powered_in!
  before_action :set_user
  before_action :set_audit, except: %i[index create destroy]

  # GET /users/:user_id/audits
  #
  # render autits index
  #
  # @return [Object] audits/index.haml
  def index
    @categories = Category.all
  end

  # POST /users/user_id/autits
  #
  # Try to make a new audit.
  # * set @audit as new audit
  # @return [Object] if audit is created render audits/category
  # otherwise status :500
  def create
    @audit = Audit.unscoped.find_or_initialize_by(
      category_id: params[:category_id],
      user_id: @user.id
    )
    @audit.category_id = params[:category_id]
    @audit.user_id = @user.id
    @audit.expire = Time.zone.now
    @audit.status = 'created'
    @audit.histories_attributes = [status: 'created', author_id: current_user.id]
    if @audit.save
      flash.now[:success] = 'Creazione avvenuta con successo'
      render partial: 'audits/category', locals: { category: @audit.category }, status: :ok
    else
      flash.now[:error] = @audit.errors.map { |k, v| "#{I18n.t k} #{v}" }.join(', ')
      head status: 500
    end
  end

  # GET /user/:user_id/audits/:id/edit
  #
  # render the form for update the audit and show his history
  # * set @audit from {set_audit}
  # * set @history with new {History} for @audit
  # * set @pagy, @history with @audit.histories pagination
  # @return [Object] render audits/edit
  def edit
    @history = @audit.histories.new
    @pagy, @histories = pagy(@audit.histories.availables.order('id DESC').limit(5), link_extra: "data-remote='true' data-action='ajax:success->audits#goPage'")
  end

  # PATCH /user/:user_id/audits/:id
  #
  # Try to update the history status
  # * set @audit from {set_audit} and try to update this with {audit_params} as param
  # * set @page, @histories with @audit.histories pagination if @audit is updated
  # * set @category with all {Category} if @audit is updated
  # * set @history with a new @audit {History}
  # @return [Object] render audits/edit
  def update
    if @audit.update(audit_params)
      @pagy, @histories = pagy(@audit.histories.availables.order('id DESC').limit(5), link_extra: "data-remote='true' data-action='ajax:success->audits#goPage'")
      @categories = Category.all
      @history = @audit.histories.new
      flash.now[:success] = 'Aggiornamento avvenuto con successo'
      render :edit, status: :ok
    else
      @history = @audit.histories.new
      flash.now[:error] = @audit.errors.map { |k, v| "#{I18n.t k} #{v}" }.join(', ')
      render :edit
    end
  end

  # DELETE /user/:user_id/audits/:id
  #
  # set the audit with status deleted
  # * set @audit searching an {Audit} with id = params[:id]
  # * set @audit.histories_attributes with status deleted
  # @return [Object] render audits/category
  def destroy
    @audit = Audit.unscoped.where('id = ? and user_id = ?', params[:id], @user.id).first
    @audit.histories_attributes = [status: 'deleted', author_id: current_user.id]
    if @audit.save
      flash.now[:success] = 'Cancellazione avvenuta con successo'
      @audit.meetings.delete_all
    end
    @categories = Category.all
    render partial: 'audits/category', locals: { category: @audit.category }
  end

  private

  # search user with params[:user_id] and set @user
  # @return [Object] User istance
  def set_user
    @user = User.find(params[:user_id])
  end

  # search audit with params[:id] for @user
  # @return [Object] Audit istance
  def set_audit
    @audit = @user.audits.find(params[:id])
  end

  # filter request params for update audits
  def audit_params
    params.fetch(:audit, {}).permit(:expire, histories_attributes: %i[author_id status doctor_id body lab revision_date])
  end
end
