import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';
import '../utils/constants.dart';
import 'glass_container.dart';

class ForecastCard extends StatelessWidget {
  final DailyForecast forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final rawDay = DateFormat.E('fr_FR').format(forecast.date);
    final dayLabel = rawDay[0].toUpperCase() + rawDay.substring(1);

    return Container(
      width: 76,
      margin: const EdgeInsets.only(right: 12),
      child: GlassContainer(
        radius: 20,
        blur: 10,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dayLabel, style: AppTypography.forecastDay),
            const SizedBox(height: 8),
            Icon(
              WeatherIconMapper.getIcon(forecast.weatherCode, isDay: true),
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text('${forecast.maxTemp.round()}°', style: AppTypography.value),
            const SizedBox(height: 2),
            Text('${forecast.minTemp.round()}°', style: AppTypography.label),
          ],
        ),
      ),
    );
  }
}