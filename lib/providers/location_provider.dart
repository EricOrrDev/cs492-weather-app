import 'package:flutter/foundation.dart';
import 'package:weatherapp/models/locations/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/locations/location_database.dart';

class LocationProvider extends ChangeNotifier {
  Location? location;

  List<Location> savedLocations = [];

  LocationDatabase? _db;

  bool useGpsOnStart = false;

  void openDatabase() async {
    _db = await LocationDatabase.open();
    await loadSavedLocations();
    await loadUseGpsOnStart();
    loadSharedZip();
  }

  Future<void> loadUseGpsOnStart() async {
    final prefs = SharedPreferencesAsync();
    useGpsOnStart = await prefs.getBool("useGpsOnStart") ?? false;
  }

  void setUseGpsOnStart(bool value) async {
    useGpsOnStart = value;
    final prefs = SharedPreferencesAsync();
    await prefs.setBool("useGpsOnStart", value);
    notifyListeners();
  }

  void loadSharedZip() async {
    if (useGpsOnStart) {
      setLocationFromGps();
      return;
    }
    if (location == null && savedLocations.isNotEmpty) {
      final prefs = SharedPreferencesAsync();
      String? savedZip = await prefs.getString("savedZip");

      for (int i = 0; i < savedLocations.length; i++) {
        if (savedLocations[i].zip == savedZip) {
          location = savedLocations[i];
          notifyListeners();
        }
      }
    }
  }

  Future<void> loadSavedLocations() async {
    if (_db != null) {
      savedLocations = (await _db?.getLocations())!;
    }

    notifyListeners();
  }

  void clearAllLocations() async {
    if (_db != null) {
      await _db?.clearAllLocations();
      location = null;
      savedLocations = [];
      saveZipToPrefs();
      loadSavedLocations();
    }
  }

  void deleteLocation(Location loc) async {
    if (_db != null) {
      await _db?.deleteLocation(loc);
      loadSavedLocations();
    }
  }

  void storeSavedLocation(Location loc) async {
    if (_db != null) {
      await _db?.insertLocation(loc);
      loadSavedLocations();
    }
  }

  void setLocationFromGps() async {
    location = await getLocationFromGps();

    if (location != null) {
      storeSavedLocation(location!);
    }
    saveZipToPrefs();
  }

  void setLocationFromString(String? locationString) async {
    if (locationString != null && locationString.trim().isNotEmpty) {
      location = await getLocationFromString(locationString);
    } else {
      location = null;
    }

    if (location != null) {
      storeSavedLocation(location!);
    }
    saveZipToPrefs();
  }

  void setLocation(Location loc) {
    location = loc;
    notifyListeners();
    saveZipToPrefs();
  }

  void saveZipToPrefs() async {
    final prefs = SharedPreferencesAsync();
    if (location != null) {
      await prefs.setString("savedZip", location!.zip);
    } else {
      await prefs.remove("savedZip");
    }
  }
}
