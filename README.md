# TryCatch Rain

A feature-rich Flutter weather application that provides real-time forecasts, historical location tracking, and dynamic visualizations. This project was developed as part of the CS492 Mobile App Development course at Oregon State University - Cascades.

## Overview

TryCatch Rain is a modern mobile application designed to give users a comprehensive view of weather conditions. It leverages the National Weather Service (NWS) API for precise data and the Pexels API to provide dynamic, context-aware background imagery that matches the current weather conditions.

### Key Features

- **Real-time Forecasts:** Daily and hourly weather data for any location in the US.
- **Dynamic Backgrounds:** Integration with the Pexels API to display stunning imagery based on short forecast descriptions (e.g., "sunny", "rainy").
- **Interactive Visualizations:** A custom-built hourly temperature graph with a dotted trend line, markers, and ruled background.
- **Location Management:** Save and manage multiple locations with a persistent SQLite database.
- **Smart GPS Integration:** Option to automatically open the app to your current GPS location.
- **Customization:** Toggle between Light and Dark modes, and switch between Fahrenheit and Celsius units.
- **Responsive Design:** Optimized for a seamless experience on both Android and iOS devices.

## How it Works

The application follows the **Provider** pattern for state management, ensuring a reactive and efficient UI.

- **Data Fetching:** Communicates with `api.weather.gov` to retrieve gridpoints and forecasts.
- **Image Integration:** Dynamically generates search queries for the Pexels API based on current weather strings.
- **Local Persistence:** Uses `sqflite` for location history and `shared_preferences` for user settings (Theme, Units, GPS preferences).
- **Custom Graphics:** Employs a `CustomPainter` to render the hourly temperature trend graph directly on the detailed forecast card.

## Deployment Instructions

To run this application locally, follow these steps:

### Prerequisites

1. **Install Flutter:**
   - Follow the official [Flutter Installation Guide](https://docs.flutter.dev/get-started/install) for your operating system.
   - Ensure `flutter doctor` passes all checks.
2. **Setup an Editor:**
   - [VS Code](https://code.visualstudio.com/) with the Flutter extension is highly recommended.

### Getting the Code

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/EricOrrDev/cs492-weather-app
   cd cs492-weather-app
   ```
2. **Configuration:**
   - Create a `.env` file in the root directory.
   - Add your Pexels API key: `PEXELS_API_KEY=your_key_here` (Get one at [Pexels API](https://www.pexels.com/api/)).

### Running the App

1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
2. **Start a Simulator/Emulator:**
   - Open an Android Emulator (via Android Studio) or iOS Simulator (via Xcode).
3. **Launch the Application:**
   ```bash
   flutter run
   ```

## Demonstration Video

Watch the full walkthrough of the application's features and implementation here:
[**WeatherWise Demonstration Video (Part 3)**](https://youtu.be/EVFiizGdELo)

---

_Developed by ERIC ORR, CS492 Student @ OSU-Cascades_
