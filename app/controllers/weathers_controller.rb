class WeathersController < ApplicationController
  before_action :set_weather, only: %i[ show edit update destroy ]

  # GET /weathers or /weathers.json
  def index
    @weathers = params[:weathers].blank? ? Weather.all : JSON.parse(params[:weathers]).map { |w| Weather.new(w) }
    @address_str = params[:address]
    @notice = params[:is_cached].to_s.casecmp('true').zero? ? ' (Cached)' : nil
  end

  # GET /weathers/1 or /weathers/1.json
  def show
  end

  # GET /weathers/new
  def new
    @address = Address.new
  end

  # GET /weathers/1/edit
  def edit
  end

  # POST /weathers or /weathers.json
  def create
  end

  # PATCH/PUT /weathers/1 or /weathers/1.json
  def update
    respond_to do |format|
      if @weather.update(weather_params)
        format.html { redirect_to @weather, notice: "Weather was successfully updated." }
        format.json { render :show, status: :ok, location: @weather }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @weather.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weathers/1 or /weathers/1.json
  def destroy
    @weather.destroy!

    respond_to do |format|
      format.html { redirect_to weathers_path, status: :see_other, notice: "Weather was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weather
      @weather = Weather.find(params[:id])
    end
end
