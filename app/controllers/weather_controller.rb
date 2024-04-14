class WeatherController < ApplicationController
  # new action:    Displays empty Address form to prompt for address components
  # create action: Takes user completed Address and uses it as search criteria to the WeatherForecaster
  #                The result from the WeatherForecaster is Weather data and is fetched/cached by postal_code
  # show action:   Uses postal_code to fetch most recent Weather data at that location

  before_action :find_weather_forecast, only: :show

  def new
    @address = Address.new
  end

  def create
    address_query = Address.new(**address_params)
    return if is_invalid_address(address_query)

    weather = WeatherForecaster.call(address_query)

    return weather_not_available_at(address_query) if weather.nil?

    redirect_to action: :show, id: weather.postal_code
  rescue StandardError => e
    weather_error(e.message)
  end

  def show; end

  private

  def find_weather_forecast
    @weather = WeatherCache.read_weather_for(params[:id])

    weather_not_available_at(params[:id]) if @weather.nil?
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :postal_code, :country)
  end

  def weather_error(msg, flash_type: :error)
    flash[flash_type] = "Weather Forecaster Error: #{msg}"
    redirect_to new_weather_path
  end

  def weather_not_available_at(location)
    weather_error("Not available at #{location}", flash_type: :notice)
  end

  def is_invalid_address(address_query)
    return false if address_query.valid?
    weather_error(address_query.errors.full_messages.join(", "))
    true
  end
end
