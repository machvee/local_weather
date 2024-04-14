# Local Weather Application

The Local Weather application is a Ruby on Rails app designed to provide weather updates for U.S. addresses. It uses external APIs to geocode addresses and fetch weather data, which is then cached to improve performance.

## Prerequisites

- Ruby Version: **3.2.2**
- Rails Version: **7.1.3.2**

This application does not use a database.

## External APIs

- **[OpenCageData](https://opencagedata.com/api#quickstart)** The OpenCage Geocoding API provides worldwide geocoding based on open data via a REST API.
- **[OpenWeatherMap](https://openweathermap.org/api)** OpenWeather provides hyperlocal minutely forecast, historical data, current state, and from short-term to annual forecasted weather data. All data is available via APIs

## Setup

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone git@github.com:machvee/local_weather.git
cd local_weather
```

### 2. Install Dependencies

Run the following command to install the necessary Ruby gems:

```bash
bundle install
```

### 3. Environment Variables
Copy the provided `.env.development` file into the Rails root directory.  This file contains API keys that should not be tracked in version control systems.

```bash
cp path/to/your/.env.development .
```

### 4. Run Tests

To ensure that everything is set up correctly, run the test suite:

```bash
bundle exec rspec
```

## Running the Application

Start the Rails server locally:

```bash
rails s
```

Navigate to `http://localhost:3000` in your web browser to access the application:


## Using the Application

### Input Requirements

Enter an address using the form provided on the home page. The address can include:

- Street
- City
- State
- Postal Code

**Note**: Only the city and state are required fields.

### Weather Data Display

After submitting an address, the weather data for that location will be displayed if available. This includes:

- Current temperature
- Low and high temperatures
- Humidity

### Caching

Weather results are cached by postal code for up to 30 minutes. While there is no explicit 'cached' indicator, the age of the last weather results for the postal code is displayed, helping you understand how recent the information is.

## Object Decomposition

### 1. WeatherForecaster

#### Responsibilities:

This Service Object orchestrates the process of fetching weather data for a given address.
Utilizes dependency injection for the geocoder and forecaster components to fetch and cache weather data.

#### Attributes:
- address_query: The address provided by the user which needs to be geocoded and used to fetch weather data.
- geocoder: An instance of a class responsible for converting addresses into geographic coordinates.
- forecaster: An instance of a class responsible for fetching weather data using geographic coordinates.

#### Methods:
- call: The primary method that handles the workflow of checking the cache, fetching new data if necessary, and returning weather data.

### 2. GeocoderAddressLookup
#### Responsibilities:
Interfaces with the Geocoder API to convert human-readable addresses into geocoded data.

#### Methods:

- search(address): Takes an Address object, queries the Geocoder API, and returns a new Address object populated with geocoded data (latitude, longitude, etc.).
- gen_postal_code(address, geocoded_address): Determines the appropriate postal code to use based on the presence of postal code data in the address and geocoded_address.

### 3. OpenWeatherMapForecaster

#### Responsibilities:

Fetches weather data from the OpenWeatherMap API using geographic coordinates.

#### Methods:

- search(address): Uses the geographic details (latitude and longitude) from an Address object to fetch weather data from the OpenWeatherMap API. Returns a Weather object populated with data like temperature and humidity.

### 4. WeatherCache

#### Responsibilities:

Manages caching of weather data to prevent excessive API calls. Ensures weather data is stored and retrieved efficiently using a postal code as the key.

#### Attributes:

- CACHE_EXPIRATION: Static attribute defining how long weather data should be cached (e.g., 30 minutes).

#### Methods:
- fetch_weather_at_location(address): Checks the cache for existing weather data for a given Address object. If data is not available, it fetches new data using a block that calls an external API.
- read_weather_for(key): Retrieves weather data from the cache using a specific key, typically the postal code.
- cache_key(key): Generates a standardized cache key from a postal code or similar identifier.

### 5. Address

#### Responsibilities:

Represents a physical address and is used across the system for geocoding and fetching weather data.

#### Attributes:
- street: The street part of the address.
- city: The city part of the address.
- state: The state part of the address.
- postal_code: Optional postal code.
- country: The country part of the address (default: United States)
- latitude: Latitude obtained from geocoding.
- longitude: Longitude obtained from geocoding.

#### Methods:
ActiveModel constructors, and validation logic.

### 6. Weather

#### Responsibilities:

- Data Representation: Represents the weather data for a specific location. It encapsulates all relevant weather details that the application needs to present to the user.
- Data Integrity: Ensures the data it contains is consistent and valid, particularly when created or updated from external API responses.

#### Attributes:

- postal_code: Stores the postal code associated with the weather data. This attribute is crucial for caching and retrieving weather information related to specific geographical areas.
- temperature: The current temperature at the specified location. This is typically a floating-point number representing the temperature in degrees Celsius or Fahrenheit.
- min_temperature: The minimum recorded temperature for the day at the location, also typically a floating-point number.
- max_temperature: The maximum recorded temperature for the day at the location.
- humidity: The current humidity percentage at the location. This is typically represented as an integer between 0 and 100.
- timestamp: The date and time when the weather data was last updated. This helps in understanding the freshness of the data and can be crucial for caching strategies.

#### Use Cases:

- Data Retrieval: The Weather class is used to store and provide weather data retrieved from an external API (like OpenWeatherMap).
- Caching: Instances of Weather are stored in a cache (keyed by postal_code) to reduce API calls for frequently requested locations.
- Data Display: Provides a convenient package of weather data that can be easily accessed and displayed in user interfaces.

### Object Interactions:

- `WeatherForecaster` uses `GeocoderAddressLookup` to transform an `Address` into geocoded coordinates and then passes this data to `OpenWeatherMapForecaster` to get the weather.
- `WeatherForecaster` also interacts with `WeatherCache` to store and retrieve cached data, minimizing API calls to geocoding and weather services.
- Both `GeocoderAddressLookup` and `OpenWeatherMapForecaster` return data that is often encapsulated within an `Address` or `Weather` object, respectively, ensuring a clean and consistent data flow across the system.
- `Weather` interacts with caching mechanisms (like WeatherCache) that store instances of Weather for specified durations.
- When weather data is fetched from an API, it is transformed into instances of the `Weather` class, standardizing the format and structure of weather data within the application.

## Additional Information

For additional support or queries, refer to the repository issues section or contact the repository maintainer.

Thank you for using Local Weather!

