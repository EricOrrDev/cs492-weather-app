import 'dart:convert';
import 'package:http/http.dart' as http;

class Forecast {
  int temperature;
  String windSpeed;
  String windDirection;
  String name;
  String shortForecast;
  String detailedForecast;
  bool isDaytime;
  String imagePath;
  DateTime startTime;
  DateTime endTime;

  Forecast(
      {required this.temperature,
      required this.windSpeed,
      required this.windDirection,
      required this.name,
      required this.shortForecast,
      required this.detailedForecast,
      required this.isDaytime,
      required this.imagePath,
      required this.startTime,
      required this.endTime});

  int getTemperature(bool isFahrenheit) {
    if (isFahrenheit) return temperature;
    return ((temperature - 32) * 5 / 9).round();
  }

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
        temperature: json["temperature"],
        windSpeed: json['windSpeed'],
        windDirection: json["windDirection"],
        name: json["name"],
        shortForecast: json["shortForecast"],
        detailedForecast: json["detailedForecast"],
        isDaytime: json["isDaytime"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        imagePath:
            getAssetFromDescription(json["shortForecast"], json["isDaytime"]));
  }
}

class HourlyForecast {
  final DateTime startTime;
  final int temperature;

  HourlyForecast({required this.startTime, required this.temperature});

  int getTemperature(bool isFahrenheit) {
    if (isFahrenheit) return temperature;
    return ((temperature - 32) * 5 / 9).round();
  }

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      startTime: DateTime.parse(json['startTime']),
      temperature: json['temperature'],
    );
  }
}

class ForecastResult {
  final List<Forecast> daily;
  final List<HourlyForecast> hourly;

  ForecastResult({required this.daily, required this.hourly});
}

Future<ForecastResult> getForecastsByLocation(double lat, double long) async {
  String pointsUrl = "https://api.weather.gov/points/$lat,$long";
  http.Response pointsResponse = await http.get(Uri.parse(pointsUrl));
  final Map<String, dynamic> pointsJson = jsonDecode(pointsResponse.body);

  final String forecastUrl = pointsJson["properties"]["forecast"];
  final String forecastHourlyUrl = pointsJson["properties"]["forecastHourly"];

  final responses = await Future.wait([
    http.get(Uri.parse(forecastUrl)),
    http.get(Uri.parse(forecastHourlyUrl)),
  ]);

  final Map<String, dynamic> forecastDetailJson = jsonDecode(responses[0].body);
  final Map<String, dynamic> forecastHourlyJson = jsonDecode(responses[1].body);

  List<Forecast> dailyForecasts = [];
  List<dynamic> dailyPeriods = forecastDetailJson["properties"]["periods"];
  for (var p in dailyPeriods) {
    dailyForecasts.add(Forecast.fromJson(p));
  }

  List<HourlyForecast> hourlyForecasts = [];
  List<dynamic> hourlyPeriods = forecastHourlyJson["properties"]["periods"];
  for (var p in hourlyPeriods) {
    hourlyForecasts.add(HourlyForecast.fromJson(p));
  }

  return ForecastResult(daily: dailyForecasts, hourly: hourlyForecasts);
}

String getAssetFromDescription(String description, bool isDaytime){
  if (description.toLowerCase().contains("sunny") || description.toLowerCase().contains("clear")){
    if (isDaytime){
      return "assets/icons/clear_day.svg";
    } else {
      return "assets/icons/clear_night.svg";
    }
  }
  if (description.toLowerCase().contains("cloudy")) {
    if (isDaytime) {
      return "assets/icons/partly_cloudy_day.svg";
    } else {
      return "assets/icons/partly_cloudy_night.svg";
    }
  }
  if (description.toLowerCase().contains("snow")) {
    if (isDaytime) {
      return "assets/icons/cloudy_with_snow_light.svg";
    } else {
      return "assets/icons/cloudy_with_snow_dark.svg";
    }
  }
  if (description.toLowerCase().contains("thunder")){
    if (isDaytime) {
      return "assets/icons/strong_thunderstorms.svg";
    } else {
      return "assets/icons/strong_thunderstorms.svg";
    }
  }
  if (description.toLowerCase().contains("rain") || description.toLowerCase().contains("drizzle") || description.toLowerCase().contains("showers")) {
    if (isDaytime) {
      return "assets/icons/showers_rain.svg";
    } else {
      return "assets/icons/showers_rain.svg";
    }
  }
  if (description.toLowerCase().contains("dust")) {
    if (isDaytime) {
      return "assets/icons/haze_fog_dust_smoke.svg";
    } else {
      return "assets/icons/haze_fog_dust_smoke.svg";
    }
  }
  if (description.toLowerCase().contains("smoke")) {
    if (isDaytime) {
      return "assets/icons/haze_fog_dust_smoke.svg";
    } else {
      return "assets/icons/haze_fog_dust_smoke.svg";
    }
  }
  if (description.toLowerCase().contains("fog")) {
    if (isDaytime) {
      return "assets/icons/haze_fog_dust_smoke.svg";
    } else {
      return "assets/icons/haze_fog_dust_smoke.svg";
    }
  }
  if (description.toLowerCase().contains("sleet")) {
    if (isDaytime) {
      return "assets/icons/mixed_rain_hail_sleet.svg";
    } else {
      return "assets/icons/mixed_rain_hail_sleet.svg";
    }
  }

  return "assets/icons/tornado.svg";
}