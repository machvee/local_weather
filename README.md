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

## Additional Information

For additional support or queries, refer to the repository issues section or contact the repository maintainer.

Thank you for using Local Weather!

