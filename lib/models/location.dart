import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:geolocator/geolocator.dart';

class Location {
  String city;
  String state;
  String zip;
  String country;
  double latitude;
  double longitude;

  Location(
      {required this.city,
      required this.state,
      required this.zip,
      required this.country,
      required this.latitude,
      required this.longitude});
}

Future<Location?> getLocationFromString(String s) async {
  try {
    List<geocoding.Location> locations = await geocoding.locationFromAddress(s);

    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(
            locations[0].latitude, locations[0].longitude);

    return Location(
        city: placemarks[0].locality ?? "",
        state: placemarks[0].administrativeArea ?? "",
        zip: placemarks[0].postalCode ?? "",
        country: placemarks[0].country ?? "",
        latitude: locations[0].latitude,
        longitude: locations[0].longitude);
  } on Exception {
    return null;
  }
}

Future<Location> getLocationFromGps() async {
  Position position = await _determinePosition();

  List<geocoding.Placemark> placemarks = await geocoding
      .placemarkFromCoordinates(position.latitude, position.longitude);

  return Location(
      city: placemarks[0].locality ?? "",
      state: placemarks[0].administrativeArea ?? "",
      zip: placemarks[0].postalCode ?? "",
      country: placemarks[0].country ?? "",
      latitude: position.latitude,
      longitude: position.longitude);
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
