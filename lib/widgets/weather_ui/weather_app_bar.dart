import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/location_provider.dart';

class WeatherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeatherAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      actions: [
        if (locationProvider.location != null)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              "${locationProvider.location!.city}, ${locationProvider.location!.state}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
      ],
    );
  }
}
