import 'package:flutter/material.dart';

import './models/forecast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

class _MyHomePageState extends State<MyHomePage> {
  List<Forecast> _forecasts = [];
  List<Widget> _forecastsWidget = [];

  @override
  void initState() {
    super.initState();
    _initForecasts();
  }

  void _initForecasts() async {
    List<Forecast> forecasts = await getForecastsByLocation(44.058, -121.315);
    setState(() {
      _forecasts = forecasts;
      // Instead of just mapping the e.name, try to create a widget that shows all properties
      _forecastsWidget =
          _forecasts.map((forecast) => buildForecastWidget(forecast)).toList();
    });
  }

  Widget buildForecastWidget(Forecast forecast) {
    return Center(
      child: ForecastCard(forecast: forecast),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  _forecastsWidget)), //credit to chatGPT for this line, idk why a normal scrollview in wrong
    );
  }
}

class ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const ForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              forecast.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${forecast.temperature}°',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              forecast.shortForecast,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
