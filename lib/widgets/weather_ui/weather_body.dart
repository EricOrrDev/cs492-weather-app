import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/widgets/forecast/forecast.dart';
import 'package:weatherapp/widgets/location/set_location/location.dart';

class WeatherAppBody extends StatelessWidget {
  const WeatherAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: locationProvider.location != null
          ? const ForecastWidget()
          : const LocationWidget(),
    );
  }
}
