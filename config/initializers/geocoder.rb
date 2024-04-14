Geocoder.configure(
  lookup: :opencagedata, # Name of geocoding service
  api_key: Rails.application.credentials.opencage[:api_key],
  timeout: 5 # geocoding service timeout (secs)
)
