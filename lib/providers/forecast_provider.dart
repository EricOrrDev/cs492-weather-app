import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/models/locations/location.dart';

class ForecastProvider extends ChangeNotifier {
  List<Forecast> forecasts = [];
  List<HourlyForecast> hourlyForecasts = [];
  Forecast? activeForecast;
  bool isFahrenheit = true;

  void setActiveForecast(Forecast forecast) {
    activeForecast = forecast;
    notifyListeners();
  }

  void loadSettings() async {
    final prefs = SharedPreferencesAsync();
    bool? fahr = await prefs.getBool("isFahrenheit");
    if (fahr != null) {
      isFahrenheit = fahr;
      notifyListeners();
    }
  }

  void setFahrenheit(bool value) async {
    isFahrenheit = value;
    notifyListeners();
    final prefs = SharedPreferencesAsync();
    await prefs.setBool("isFahrenheit", value);
  }

  void getForecasts(Location? location) async {
    if (location != null) {
      final result =
          await getForecastsByLocation(location.latitude, location.longitude);
      forecasts = result.daily;
      hourlyForecasts = result.hourly;
      activeForecast = forecasts[0];
    }
    notifyListeners();
  }
}
