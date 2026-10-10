# WeatherAp 🌦️

A weather application built with **Flutter and Dart**, using the Open-Meteo API to retrieve weather data and provide forecasts for cities around the world.

WeatherAp is a personal portfolio project focused on API integration, asynchronous data handling, location search, data presentation, and multilingual user interfaces.

## Features

* **Current Weather:** Retrieve weather information for selected locations.
* **City Search:** Search for cities using location suggestions.
* **Weather Forecasts:** View forecast information for upcoming days.
* **Weather Map:** Explore weather-related information through an integrated map.
* **City Visuals:** Display location images for supported cities when available.
* **Multilingual Interface:** Switch between English, Spanish, and French.
* **Default Location:** Start with San Lorenzo, Honduras.
* **Modern UI:** A blue gradient design with dedicated weather information and forecast cards.

## Technologies

* **Flutter** — Cross-platform application development.
* **Dart** — Application logic and asynchronous programming.
* **Open-Meteo API** — Weather data.
* **Geocoding** — City search and location lookup.
* **Flutter Localization** — Multilingual support.
* **Git and GitHub** — Version control and project hosting.

## Getting Started

### Prerequisites

Make sure you have the following installed:

* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
* [Visual Studio Code](https://code.visualstudio.com/) or another compatible IDE
* An emulator, simulator, or supported device

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/fernandogarciamendoza1996-dotcom/weatherap.git
   ```

2. Navigate to the project directory:

   ```bash
   cd weatherap
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## API

WeatherAp uses the [Open-Meteo API](https://open-meteo.com/) to retrieve weather information.

Review the API documentation for details about available weather data and services.

## Project Structure

The application code is organized into folders for different responsibilities:

```text
lib/
├── models/       # Weather data models
├── services/     # API and geocoding services
├── widgets/      # Reusable UI components
├── utils/        # Helper functions
└── l10n/         # Localization resources
```

*Note: This is a simplified overview of the main application code.*

## What I Learned

Through this project, I practiced:

* Consuming REST APIs and processing JSON responses.
* Handling asynchronous operations in Dart.
* Organizing a Flutter application into models, services, and reusable widgets.
* Implementing city search and location-based weather queries.
* Building a multilingual interface.
* Using Git and GitHub to manage and publish source code.

## Future Improvements

* Further refine the user interface and user experience.
* Expand weather visualization and forecast details.
* Improve error handling and loading states.
* Continue expanding the application's features.

## Author

**Fernando Garcia Mendoza**

Engineering student in Systems Engineering, building practical projects with Flutter and exploring software development.

[GitHub Profile](https://github.com/fernandogarciamendoza1996-dotcom)

---

*WeatherAp is a personal learning and portfolio project.*
