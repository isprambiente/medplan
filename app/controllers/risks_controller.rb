# frozen_string_literal: true

# This controller manage the views refering to {Risk} model
# * before_action :{powered_in!}
# * before_action :set_risk, only: [:edit, :update, :destroy]
class RisksController < ApplicationController
  include Pagy::Backend
  before_action :powered_in!
  before_action :set_risk, only: %i[edit update destroy]
  before_action :set_view

  # GET /risks
  #
  # Show a list of {Risk}
  # * set @risks with {risks}
  # @return [Object] render risks/index
  def index; end

  # GET /audits/list
  #
  # render the list the all {Audit}
  # * set @pagy, @audits for the @users pagination
  # @return [Object] render users/index
  def list
    @pagy, @risks = pagy(risks, link_extra: "data-turbo-frame='risks'")
  end

  # GET /risks/new
  #
  # render the form for make a new category {Risk}
  # * set @risk as new {Risk}
  # @return [Object] render risk/new
  def new
    @risk = Risk.new
  end

  # GET /risks/:id/edit
  #
  # render the form for update a category {Risk}
  # * set @risk with {set_risk} method
  # @return [Object] render risk/edit
  def edit
    # empty
  end

  # POST /risks
  #
  # try to make a new category {Risk}
  #
  # * set @risk with new {Risk} with {risk_params} as params
  # @return [Object] if @risk is created render /risks/index otherwise render /risk/edit
  def create
    @risk = Risk.new(risk_params)
    if @risk.save
      risks
      flash.now[:success] = 'Creazione avvenuta con successo'
      render :index, status: :ok
    else
      flash.now[:error] = 'Si è verificato un errore durante la creazione'
      render :edit, status: :error
    end
  end

  # PATCH/PUT /risks/:id/
  #
  # try to update a category {Risk}
  # * set @risk with {set_risk} method
  # * update @risk with {risk_params} as param
  # @return [Object] if @risk is updated render risks/index otherwise risks/edit
  def update
    if @risk.update(risk_params)
      risks
      flash.now[:success] = 'Modifica avvenuta con successo'
      render :index, status: :ok
    else
      flash.now[:error] = 'Si è verificato un errore durante la modifica'
      render :edit, status: :error
    end
  end

  # DELETE /risks/:id
  #
  # Destroy a {Risk} category
  # * set @risk with {set_risk} method
  # * try to destroy @risk
  # @return [Object] render
  def destroy
    if @risk.destroy
      flash.now[:success] = 'Cancellazione avvenuta con successo'
    else
      flash.now[:error] = 'Si è verificato un errore durante la cancellazione'
    end
    render turbo_stream: [
      turbo_stream.replace(:flashes, partial: "flashes"),
      turbo_stream.remove("risk_#{@risk.id}")
    ]
  end

  private

  # Set @risk for many action
  # * set @risk searching {Risk} with id == params[:id]
  # @return [Object] @risk
  def set_risk
    @risk = Risk.find(params[:id])
  end

  # Filter request params for create and update the risks
  # @return [Hash] filtered params
  def risk_params
    params.fetch(:risk, {}).permit(:code, :title, :printed, category_ids: [])
  end

  # Set callback view
  def set_view
    @view = filter_params[:view] || ''
  end

  # Only allow a list of trusted parameters through.
  def filter_params
    params.fetch(:filter, {}).permit(:view)
  end

  # set the risks for the lists actions
  # * set @pagy, @risks with the pagination of all {Risk}
  def risks
    @risks = Risk.all
  end
end
