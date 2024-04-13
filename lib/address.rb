class Address
  attr_accessor :street, :city, :state, :postal_code, :country, :latitude, :longitude

  DEFAULT_COUNTRY = 'United States'

  def initialize(street: nil, city: nil, state: nil, postal_code: nil, country: DEFAULT_COUNTRY, latitude: nil, longitude: nil)
    @street = street
    @city = city
    @state = state
    @postal_code = postal_code
    @country = country
    @latitude = latitude
    @longitude = longitude
  end

  # A method to return a formatted address string
  def to_s
    "#{@street}, #{@city}, #{@state}, #{@postal_code}, #{@country}"
  end

  # Optional: A method to update latitude and longitude
  def update_coordinates(lat, lng)
    @latitude = lat
    @longitude = lng
  end

  def key
    @postal_code.present? ? @postal_code : "#{@city}_#{@state}"
  end
end
