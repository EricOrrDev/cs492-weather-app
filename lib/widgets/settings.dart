import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle between light and dark themes'),
            value: themeProvider.darkMode,
            onChanged: (bool value) {
              themeProvider.setDarkMode(value);
            },
            secondary: const Icon(Icons.brightness_4),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Open to Current Location'),
            subtitle: const Text('Automatically detect location on startup'),
            value: locationProvider.useGpsOnStart,
            onChanged: (bool value) {
              locationProvider.setUseGpsOnStart(value);
            },
            secondary: const Icon(Icons.gps_fixed),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text('Clear All Locations', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Delete all saved locations from history'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Clear Locations?'),
                    content: const Text('This will delete all your saved locations. This action cannot be undone.'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Clear', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          locationProvider.clearAllLocations();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
