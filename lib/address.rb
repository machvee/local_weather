class Address
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :street, :city, :state, :postal_code, :country, :latitude, :longitude

  validates :city, :state, presence: true
  validates :postal_code,
    format: { with: /\A\d{5}(-\d{4})?\z/, message: "must be a valid ZIP code" },
    allow_blank: true

  DEFAULT_COUNTRY = 'United States'

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end
  end

  def persisted?
    false
  end

  # A method to return a formatted address string
  def to_s
    opt_postal_code = @postal_code.present? ? ", #{postal_code}" : ''
    "#{@street}, #{@city}, #{@state}#{opt_postal_code}"
  end

  def key
    catented_city_state = -> { "#{@city}_#{@state}".gsub(/\s+/, '_') }
    @postal_code.present? ? @postal_code : catented_city_state.call
  end
end
