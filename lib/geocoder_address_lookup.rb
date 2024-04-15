class GeocoderAddressLookup
  def self.search(address_query)
    #
    # Uses the geocoder gem to search for Geocoded coordinates using
    # an Address Object.  The Geocoder is flexibly configured with a specific
    # API to use to fetch publicly available Map data. (see config/initializers/geocoder.rb)
    #
    results = Geocoder.search(address_query.to_s)

    return nil unless results.any?

    geocoded_address = results.first

    postal_code = gen_postal_code(address_query, geocoded_address)

    Address.new(
      street: geocoded_address.street,
      city: geocoded_address.city,
      state: geocoded_address.state,
      postal_code: postal_code,
      latitude: geocoded_address.latitude,
      longitude: geocoded_address.longitude
    )
  end

  def self.gen_postal_code(address_query, geocoded_address)
    # Use the Geocoded postal_code first, but sometimes these are not available from the API.
    # Otherwise, use the input address_query if postal_code is present there.
    # Otherwise, the postal_code is nil
    return geocoded_address.postal_code if geocoded_address.postal_code.present?
    return address_query.postal_code if address_query.postal_code.present?
    nil
  end
end
