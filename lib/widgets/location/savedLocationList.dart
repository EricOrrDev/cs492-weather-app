import 'package:flutter/material.dart';
import 'package:weatherapp/providers/location_provider.dart';

class SavedLocationsList extends StatelessWidget {
  const SavedLocationsList({
    super.key,
    required this.locationProvider,
  });

  final LocationProvider locationProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 500,
        width: 500,
        child: ListView(
            scrollDirection: Axis.vertical,
            children: locationProvider.savedLocations.values
                .map((e) => Text(e.zip))
                .toList()));
  }
}
