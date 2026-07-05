import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather.dart';
import '../utils/constants.dart';
import 'glass_container.dart';
import 'package:provider/provider.dart';
import '../utils/theme_provider.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(weather.cityName.toUpperCase(), style: AppTypography.cityName),
        const SizedBox(height: 12),
        Icon(
          WeatherIconMapper.getIcon(weather.weatherCode, isDay: weather.isDay),
          size: 100,
          color: Colors.white,
          shadows: const [
            Shadow(color: Color(0x40000000), blurRadius: 20, offset: Offset(0, 6)),
          ],
        ),
        const SizedBox(height: 4),
        Text('${weather.temperature.round()}°', style: AppTypography.temperature),
        Text(
          WeatherIconMapper.getLabel(weather.weatherCode),
          style: AppTypography.condition,
        ),
        const SizedBox(height: 20),
        GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.air_rounded,
                label: 'Vent',
                value: '${weather.windSpeed.round()} km/h',
              ),
              const _VerticalDivider(),
              _StatItem(
                icon: Icons.water_drop_rounded,
                label: 'Humidité',
                value: '${weather.humidity}%',
              ),
              const _VerticalDivider(),
              _StatItem(
                icon: Icons.thermostat_rounded,
                label: 'Ressenti',
                value: '${weather.feelsLike.round()}°C',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GlassContainer(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.wb_twilight_rounded,
                label: 'Lever',
                value: DateFormat('HH:mm').format(weather.sunrise),
              ),
              const _VerticalDivider(),
              _StatItem(
                icon: Icons.nights_stay_rounded,
                label: 'Coucher',
                value: DateFormat('HH:mm').format(weather.sunset),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 22),
        const SizedBox(height: 8),
        Text(value, style: AppTypography.value),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.label),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(height: 42, width: 1, color: AppColors.glassBorder(isDark));
  }
}