import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
=======

>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
import 'package:weatherapp/widgets/detailed_forecast.dart';
import 'package:weatherapp/widgets/forecasts.dart';

class ForecastWidget extends StatelessWidget {
<<<<<<< HEAD
  const ForecastWidget({
    super.key,
    required ForecastProvider forecastProvider,
  }) : _forecastProvider = forecastProvider;

  final ForecastProvider _forecastProvider;
=======
  const ForecastWidget({super.key});
>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 200,
<<<<<<< HEAD
          child: ForecastsWidget(
            forecasts: _forecastProvider.forecasts,
            setActiveForecast: _forecastProvider.setActiveForecast,
          ),
        ),
        DetailedForecast(activeForecast: _forecastProvider.activeForecast)
=======
          child: ForecastsWidget(),
        ),
        DetailedForecast()
>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
      ],
    );
  }
}
