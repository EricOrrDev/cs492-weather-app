import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
import 'forecast_tile.dart';

class ForecastsRowWidget extends StatelessWidget {
  const ForecastsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final forecastProvider = context.watch<ForecastProvider>();
    final allForecasts = forecastProvider.forecasts;

    if (allForecasts.isEmpty) return const SizedBox.shrink();

    final List<Forecast> filteredForecasts = [];

    for (int i = 0; i < allForecasts.length; i++) {
      final forecast = allForecasts[i];

      if (i == 0) {
        // First tile: Always call it "Today" for a consistent start
        forecast.name = "Today";
        filteredForecasts.add(forecast);
      } else {
        // Subsequent tiles: Only include daytime periods to ensure one tile per day
        if (forecast.isDaytime) {
          filteredForecasts.add(forecast);
        }
      }
    }
    return ListView(
        scrollDirection: Axis.horizontal,
        children: filteredForecasts
            .map((forecast) => ForecastTileWidget(forecast: forecast))
            .toList());
  }
}
