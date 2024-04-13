class GeocoderAddressLookup
  def self.search(address)
    results = Geocoder.search(address.to_s)

    return nil unless results.any?

    geocoded_address = results.first

    postal_code = gen_postal_code(address, geocoded_address)

    Address.new(
      street: geocoded_address.street,
      city: geocoded_address.city,
      state: geocoded_address.state,
      postal_code: postal_code,
      country: geocoded_address.country,
      latitude: geocoded_address.latitude,
      longitude: geocoded_address.longitude
    )
  end

  def self.gen_postal_code(address, geocoded_address)
    return geocoded_address.postal_code if geocoded_address.postal_code.present?
    return address.postal_code if address.postal_code.present?
    nil
  end
end
