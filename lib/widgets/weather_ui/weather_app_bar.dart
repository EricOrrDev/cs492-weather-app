import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/providers/theme_provider.dart';

class WeatherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WeatherAppBar({
    super.key,
    required this.title,
    required TabController tabController,
  }) : _tabController = tabController;

  final String title;
  final TabController _tabController;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      actions: [
        Semantics(
          label: 'Dark Mode Toggle',
          checked: themeProvider.darkMode,
          child: Switch(
              value: themeProvider.darkMode,
              onChanged: (value) => {themeProvider.setDarkMode(value)}),
        ),
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
      bottom: TabBar(controller: _tabController, tabs: [
        Tab(
            icon: Semantics(
                label: "Weather Tab", child: const Icon(Icons.sunny_snowing))),
        Tab(
            icon: Semantics(
                label: "Location Tab", child: const Icon(Icons.location_pin))),
      ]),
    );
  }
}
