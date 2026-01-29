import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/widgets/detailed_forecast.dart';
import 'package:weatherapp/widgets/forecasts.dart';

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({
    super.key,
    required ForecastProvider forecastProvider,
  }) : _forecastProvider = forecastProvider;

  final ForecastProvider _forecastProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
          child: ForecastsWidget(
            forecasts: _forecastProvider.forecasts,
            setActiveForecast: _forecastProvider.setActiveForecast,
          ),
        ),
        DetailedForecast(activeForecast: _forecastProvider.activeForecast)
      ],
    );
  }
}
