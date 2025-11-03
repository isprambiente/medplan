# frozen_string_literal: true

# This controller manage the views refering to {Category} model
# === before_action :{powered_in!}
# === before_action :{set_category}, only: [:edit, :update, :destroy]
class CategoriesController < ApplicationController
  include Pagy::Method
  before_action :powered_in!
  before_action :set_category, only: %i[edit update destroy]
  before_action :set_view

  # GET /categories
  #
  # render categories index
  # set @pagy, @categories for the categorie pagination
  # @return [Object] render categories/index
  def index; end

  # GET /categories/list
  #
  # render the list the all {Audit}
  # * set @pagy, @categories for the @categories pagination
  # @return [Object] render categories/index
  def list
    @pagy, @categories = pagy(categories, link_extra: "data-turbo-frame='categories'")
  end

  # GET /categories/new
  #
  # Render the form for create a new category
  # set @category as new {Category}
  # @return [Object] rendeer categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  #
  # Render the form for edit a category
  # {set_category} has set @category for edit
  # @return [Object] render categories/edit
  def edit; end

  # POST /categories
  #
  # Create a new Category
  # set @category as new {Category} with {category_params} as param
  # @return [Object] render categories/index if @category is created or categories/new if fail
  def create
    @category = Category.new(category_params)
    if @category.save
      categories
      flash.now[:success] = 'Creazione avvenuta con successo'
      render :index, status: :ok
    else
      flash.now[:error] = 'Si è verificato un errore durante la creazione'
      render :new, status: :error
    end
  end

  # PATCH/PUT /categories/1
  #
  # update a category
  # {set_category} has set @category for update
  # and update with {category_params} as param
  # @return [Object] render categories/index if @category is updated or categories/new if fail
  def update
    if @category.update(category_params)
      categories
      flash.now[:success] = 'Modifica avvenuta con successo'
      render :index, status: :ok
    else
      flash.now[:error] = 'Si è verificato un errore durante la modifica'
      render :edit, status: :error
    end
  end

  # DELETE /categories/1
  #
  # destroy a category
  #
  # * {set_category} has set @category for destroy
  # @return [Object] render categories/index
  def destroy
    if @category.destroy
      flash.now[:success] = 'Cancellazione avvenuta con successo'
    else
      flash.now[:error] = 'Si è verificato un errore durante la cancellazione'
    end
    render turbo_stream: [
      turbo_stream.replace(:flashes, partial: "flashes"),
      turbo_stream.remove("category_#{@category.id}")
    ]
  end

  private

  # Set @category with params[:id]
  # @return [Object] istance of {Category}
  def set_category
    @category = Category.find(params[:id])
  end

  # Filter params for create and update {Category}
  # return [Object] instance of params
  def category_params
    params.fetch(:category, {}).permit(:code, :title, :months, :protocol, risk_ids: [])
  end

  # Set callback view
  def set_view
    @view = filter_params[:view] || ''
  end

  # Only allow a list of trusted parameters through.
  def filter_params
    params.fetch(:filter, {}).permit(:view)
  end

  # Set @pagy, @categories for paginate all {Category}
  def categories
    Category.all
  end
end
