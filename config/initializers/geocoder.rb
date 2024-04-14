Geocoder.configure(
  lookup: :opencagedata, # Name of geocoding service
  api_key: (ENV['OPEN_CAGE_DATA_API_KEY'] || Rails.application.credentials.opencage[:api_key]),
  timeout: 5 # geocoding service timeout (secs)
)
