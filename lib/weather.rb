class Weather
  attr_reader :postal_code, :temperature, :min_temperature, :max_temperature, :humidity, :timestamp

  def initialize(postal_code:, temperature:, min_temperature:, max_temperature:, humidity:)
    @postal_code = postal_code
    @temperature = temperature
    @min_temperature = min_temperature
    @max_temperature = max_temperature
    @humidity = humidity
    @timestamp = Time.current
  end

  def to_param
    @postal_code
  end
end
