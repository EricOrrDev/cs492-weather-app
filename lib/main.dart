import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
<<<<<<< HEAD
=======

>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/widgets/weather_app_bar.dart';
import 'package:weatherapp/widgets/weather_body.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LocationProvider()),
    ChangeNotifierProvider(create: (context) => ForecastProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CS492',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CS492'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
<<<<<<< HEAD
  final LocationProvider _locationProvider = LocationProvider();
  final ForecastProvider _forecastProvider = ForecastProvider();
=======
  bool locationSet = false;
>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 1;
    _tabController.addListener(() {
      if (!locationSet) {
        _tabController.animateTo(1);
      }
    });
  }

<<<<<<< HEAD
  void _setActiveForecast(Forecast forecast) {
    setState(() {
      _forecastProvider.activeForecast = forecast;
    });
  }

  void _getForecasts(Location? location) async {
    if (location != null) {
      _forecastProvider.forecasts =
          await getForecastsByLocation(location.latitude, location.longitude);
=======
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locationProvider = context.read<LocationProvider>();
    final forecastProvider = context.read<ForecastProvider>();

    if (locationProvider.location != null) {
      locationSet = true;
      forecastProvider.getForecasts(locationProvider.location);
    } else {
      locationSet = false;
>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            if (_locationProvider.location != null)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "${_locationProvider.location!.city}, ${_locationProvider.location!.state}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                ),
              ),
          ],
          bottom: TabBar(controller: _tabController, tabs: [
            Tab(icon: Icon(Icons.sunny_snowing)),
            Tab(
              icon: Icon(Icons.location_pin),
            )
          ])),
      body: SizedBox(
        height: double.infinity,
        width: 500,
        child: TabBarView(
          controller: _tabController,
          children: [
            ForecastWidget(forecastProvider: _forecastProvider),
            LocationWidget(locationProvider: _locationProvider),
          ],
        ),
      ),
=======
      appBar: WeatherAppBar(title: widget.title, locationProvider: locationProvider, tabController: _tabController),
      body: WeatherAppBody(tabController: _tabController),
>>>>>>> 76da1f959dc4fb4c5b0090a7cbc338e8bb94f926
    );
  }
}
