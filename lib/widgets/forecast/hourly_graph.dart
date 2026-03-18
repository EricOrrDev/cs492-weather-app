import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/models/forecast.dart';
import 'package:weatherapp/providers/forecast_provider.dart';
import 'package:weatherapp/providers/theme_provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class HourlyTemperatureGraph extends StatelessWidget {
  const HourlyTemperatureGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final forecastProvider = context.watch<ForecastProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final activeForecast = forecastProvider.activeForecast;
    
    List<HourlyForecast> hourlyForecasts = [];

    if (activeForecast != null && forecastProvider.hourlyForecasts.isNotEmpty) {
      // Determine if this is the very first tile in the list
      final isFirstTile = forecastProvider.forecasts.isNotEmpty && 
                          forecastProvider.forecasts.first == activeForecast;
      
      // Trend length: 12h for current/first period, 24h for everything else
      final trendLength = isFirstTile ? 12 : 24;

      // Show hours starting from the beginning of the selected period
      hourlyForecasts = forecastProvider.hourlyForecasts.where((hourly) {
        return (hourly.startTime.isAtSameMomentAs(activeForecast.startTime) || 
                hourly.startTime.isAfter(activeForecast.startTime));
      }).take(trendLength).toList();
    }

    // Fallback if filtering results in no data
    if (hourlyForecasts.isEmpty) {
      hourlyForecasts = forecastProvider.hourlyForecasts.take(12).toList();
    }

    if (hourlyForecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 150, // Integrated height
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: CustomPaint(
        size: Size.infinite,
        painter: _TemperaturePainter(
          forecasts: hourlyForecasts,
          isDarkMode: themeProvider.darkMode,
          isFahrenheit: forecastProvider.isFahrenheit,
        ),
      ),
    );
  }
}

class _TemperaturePainter extends CustomPainter {
  final List<HourlyForecast> forecasts;
  final bool isDarkMode;
  final bool isFahrenheit;

  _TemperaturePainter({
    required this.forecasts,
    required this.isDarkMode,
    required this.isFahrenheit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (forecasts.isEmpty) return;

    final temps = forecasts.map((f) => f.getTemperature(isFahrenheit)).toList();
    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final tempRange = (maxTemp - minTemp).toDouble().clamp(5, 100);

    final paddingHorizontal = 20.0;
    final paddingTop = 20.0;
    final paddingBottom = 20.0;
    final graphWidth = (size.width - (paddingHorizontal * 2)).clamp(0, double.infinity);
    final graphHeight = (size.height - paddingTop - paddingBottom).clamp(0, double.infinity);

    final xStep = forecasts.length > 1 ? graphWidth / (forecasts.length - 1) : 0.0;
    
    final points = <Offset>[];
    for (var i = 0; i < forecasts.length; i++) {
      final x = forecasts.length > 1 
          ? paddingHorizontal + (i * xStep)
          : size.width / 2; // Center the single point
      final normalizedTemp = tempRange > 0 ? (temps[i] - minTemp) / tempRange : 0.5;
      final y = size.height - paddingBottom - (normalizedTemp * graphHeight);
      points.add(Offset(x, y));
    }

    // 1. Draw ruled lines (Grid)
    final gridPaint = Paint()
      ..color = isDarkMode ? Colors.white10 : Colors.black12
      ..strokeWidth = 1;
    
    const gridLines = 3;
    for (var i = 0; i <= gridLines; i++) {
      final y = paddingTop + (i * graphHeight / gridLines);
      canvas.drawLine(Offset(paddingHorizontal, y), Offset(size.width - paddingHorizontal, y), gridPaint);
    }

    // 2. Draw dotted line
    final linePaint = Paint()
      ..color = Colors.blueAccent.withValues(alpha: 0.4)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < points.length - 1; i++) {
      _drawDashedLine(canvas, points[i], points[i + 1], linePaint);
    }

    // 3. Draw dots (markers) and labels
    final dotPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    final dotOutlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

    // Denser labeling for 12h, sparser for 24h
    final labelInterval = forecasts.length > 12 ? 4 : 2;

    for (var i = 0; i < points.length; i++) {
      // Draw dot
      canvas.drawCircle(points[i], 4, dotPaint);
      canvas.drawCircle(points[i], 4, dotOutlinePaint);

      // Draw Time label
      if (i % labelInterval == 0) {
        final time = DateFormat('h a').format(forecasts[i].startTime);
        textPainter.text = TextSpan(
          text: time,
          style: TextStyle(color: Colors.white70, fontSize: 9),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(points[i].dx - (textPainter.width / 2), size.height - 12));
      }

      // Draw Temp label
      if (i % labelInterval == 0 || i == points.length - 1) {
        textPainter.text = TextSpan(
          text: '${temps[i]}°',
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(points[i].dx - (textPainter.width / 2), points[i].dy - 18));
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4;
    const dashSpace = 4;
    
    final distance = (p2 - p1).distance;
    final dx = (p2.dx - p1.dx) / distance;
    final dy = (p2.dy - p1.dy) / distance;
    
    var currentDist = 0.0;
    while (currentDist < distance) {
      final start = p1 + Offset(dx * currentDist, dy * currentDist);
      currentDist += dashWidth;
      if (currentDist > distance) currentDist = distance;
      final end = p1 + Offset(dx * currentDist, dy * currentDist);
      canvas.drawLine(start, end, paint);
      currentDist += dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
