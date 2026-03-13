import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/models/pexels_image.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/providers/theme_provider.dart';
import 'package:weatherapp/widgets/forecast/detailed_forecast/detailed_forecast_text.dart';

class DetailedForecast extends StatefulWidget {
  const DetailedForecast({super.key});

  @override
  State<DetailedForecast> createState() => _DetailedForecastState();
}

class _DetailedForecastState extends State<DetailedForecast> {
  String? _imageUrl;
  Forecast? _lastForecast;
  bool _loading = false;
  PexelsImage pexelsImage = PexelsImage();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final activeForecast = context.watch<ForecastProvider>().activeForecast;

    if (activeForecast != null && activeForecast != _lastForecast) {
      _lastForecast = activeForecast;
      setState(() {
        _imageUrl = null;
        _loading = true;
      });
      _fetchAndUpdateImage(activeForecast);
    }
  }

  Future<void> _fetchAndUpdateImage(Forecast forecast) async {
    String day = forecast.isDaytime ? "Day" : "Night";
    String cleanedQuery = _cleanQuery(forecast.shortForecast);

    String prompt = "$day $cleanedQuery".trim();

    final imageUrl = await pexelsImage.getImage(prompt);

    if (!mounted) return;

    setState(() {
      _imageUrl = imageUrl;
      _loading = false;
    });
  }

  String _cleanQuery(String shortForecast) {
    String query = shortForecast.toLowerCase();

    // Handle "Chance of ..." cases to avoid casinos/gambling results
    if (query.contains('chance')) {
      if (query.contains('rain')) return 'rainy weather';
      if (query.contains('snow')) return 'snowy landscape';
      if (query.contains('thunderstorm')) return 'thunderstorm';
      if (query.contains('shower')) return 'rain showers';
    }

    // Map common weather terms to more landscape/scenery-focused terms for better images
    // and to avoid generic sky photos that often feature birds.
    final Map<String, String> mappings = {
      'mostly sunny': 'sunny sky landscape',
      'partly sunny': 'partly cloudy sky',
      'mostly cloudy': 'cloudy sky landscape',
      'partly cloudy': 'scattered clouds sky',
      'sunny': 'clear sunny day',
      'clear': 'clear sky landscape',
      'cloudy': 'overcast sky',
      'rain': 'rainy weather',
      'showers': 'rain showers',
      'snow': 'snowy weather',
      'thunderstorm': 'lightning storm',
      'fog': 'foggy weather landscape',
      'haze': 'hazy sky',
      'blizzard': 'snow storm',
    };

    for (var entry in mappings.entries) {
      if (query.contains(entry.key)) {
        return entry.value;
      }
    }

    // Default to the original if no specific mapping found
    return query;
  }

  @override
  Widget build(BuildContext context) {
    final activeForecast = context.watch<ForecastProvider>().activeForecast;
    final themeProvider = context.read<ThemeProvider>();

    if (activeForecast == null) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Text(
            'Select a forecast to see details',
            style: TextStyle(color: themeProvider.grey),
          ),
        ),
      );
    }

    return ExcludeSemantics(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Card(
          elevation: 3,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background image
              if (_imageUrl != null)
                Positioned.fill(
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.black.withValues(alpha: 0.5),
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.white54, size: 50),
                        ),
                      );
                    },
                  ),
                ),
      
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
              DetailedForecastText(activeForecast: activeForecast),
              if (_loading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (!_loading && _imageUrl == null)
                 const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.white70, size: 30),
                        SizedBox(height: 8),
                        Text(
                          'Image unavailable\n(Check console for Pexels errors)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
