import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/models/location.dart';

class ForecastProvider extends ChangeNotifier {
  Forecast? activeForecast;
  List<Forecast> forecasts = [];

  void setActiveForecast(Forecast forecast) {
    activeForecast = forecast;
    notifyListeners();
  }

  void getForecasts(Location? location) async {
    if (location != null) {
      forecasts =
          await getForecastsByLocation(location.latitude, location.longitude);
      setActiveForecast(forecasts.first);
    }
    notifyListeners();
  }
}
