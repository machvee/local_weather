class Weather
  attr_reader :postal_code, :temperature, :humidity

  def initialize(postal_code:, temperature:, humidity:)
    @postal_code = postal_code
    @temperature = temperature
    @humidity = humidity
  end

  def to_param
    @postal_code
  end
end
