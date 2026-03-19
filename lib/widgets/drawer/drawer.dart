import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/widgets/settings.dart';
import 'package:weatherapp/widgets/location/add_location_dialog.dart';

class WeatherDrawer extends StatelessWidget {
  const WeatherDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_cloudy, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'TryCatch Rain',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_location_alt),
            title: const Text('Add Location'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              showDialog(
                context: context,
                builder: (context) => const AddLocationDialog(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('Current Location (GPS)'),
            onTap: () {
              locationProvider.setLocationFromGps();
              Navigator.of(context).pop(); // Close drawer
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Saved Locations',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: locationProvider.savedLocations.isEmpty
                ? const Center(child: Text('No saved locations'))
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: locationProvider.savedLocations.length,
                    itemBuilder: (context, index) {
                      final location = locationProvider.savedLocations[index];
                      final isSelected =
                          locationProvider.location?.zip == location.zip;

                      return ListTile(
                        title: Text("${location.city}, ${location.state}"),
                        subtitle: Text(location.zip),
                        selected: isSelected,
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          locationProvider.setLocation(location);
                          Navigator.of(context).pop(); // Close drawer
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
