<<<<<<< HEAD
import 'package:flutter/material.dart';
=======
import 'package:flutter/foundation.dart';

>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/models/location.dart';

class ForecastProvider extends ChangeNotifier {
<<<<<<< HEAD
  Forecast? activeForecast;
  List<Forecast> forecasts = [];

=======
  List<Forecast> forecasts = [];
  Forecast? activeForecast;
>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
  void setActiveForecast(Forecast forecast) {
    activeForecast = forecast;
    notifyListeners();
  }

  void getForecasts(Location? location) async {
    if (location != null) {
      forecasts =
          await getForecastsByLocation(location.latitude, location.longitude);
<<<<<<< HEAD
      setActiveForecast(forecasts.first);
=======
      activeForecast = forecasts[0];
>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
    }
    notifyListeners();
  }
}
