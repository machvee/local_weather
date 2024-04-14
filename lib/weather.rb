class Weather
  attr_reader :postal_code, :temperature, :humidity, :timestamp

  def initialize(postal_code:, temperature:, humidity:)
    @postal_code = postal_code
    @temperature = temperature
    @humidity = humidity
    @timestamp = Time.current
  end

  def to_param
    @postal_code
  end
end
