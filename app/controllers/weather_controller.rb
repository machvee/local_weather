class WeatherController < ApplicationController

  before_action :find_weather_forecast, only: :show

  def new
    @address = Address.new
  end

  def create
    weather = WeatherForecaster.call(Address.new(**address_params))

    redirect_to action: :show, id: weather
  end

  def show; end

  private

  def find_weather_forecast
    @weather = Rails.cache.read(params[:id])
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :postal_code, :country)
  end
end
