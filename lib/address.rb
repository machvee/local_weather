class Address
  #
  # Address
  #
  # An ActiveModel object used to capture and validate search
  # form data entry, and as criteria to perform weather searches 
  #
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :street, :city, :state, :postal_code, :latitude, :longitude

  validates :city, :state, presence: true
  validates :postal_code,
    format: { with: /\A\d{5}(-\d{4})?\z/, message: "must be a valid ZIP code" },
    allow_blank: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end
  end

  def persisted?
    false
  end

  def to_s
    # A method to return a formatted address string.  This string form of the
    # address is used for user address display and as search criteria when searching
    # for associated weather
    opt_postal_code = @postal_code.present? ? ", #{postal_code}" : ''
    "#{@street}, #{@city}, #{@state}#{opt_postal_code}"
  end

  def key
    # aids in determining unique hash key for weather data associated with the Address
    catenated_city_state = -> { "#{@city}_#{@state}".gsub(/\s+/, '_') }
    @postal_code.present? ? @postal_code : catenated_city_state.call
  end
end
