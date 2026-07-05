import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';
import '../utils/theme_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/glass_container.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  Weather? _weather;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeather('Abidjan');
  }

  Future<void> _loadWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCity(city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ville introuvable. Réessaie avec un autre nom.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherFromLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _locationService.getCurrentPosition();
      final weather = await _weatherService.getWeatherByCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: 'Ma position',
      );
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _loadWeatherFromCoordinates(
      String cityName, double lat, double lon) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCoordinates(
        latitude: lat,
        longitude: lon,
        cityName: cityName,
      );
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Impossible de charger la météo pour cette ville.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final gradient = _weather != null
        ? WeatherGradients.getGradient(_weather!.weatherCode, isDay: _weather!.isDay)
        : WeatherGradients.getGradient(1, isDay: true);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: gradient),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: double.infinity,
            height: double.infinity,
            color: AppColors.overlay(isDark),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text('Weather App', style: AppTypography.value.copyWith(fontSize: 17)),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: _weather == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsScreen(weather: _weather!),
                                    ),
                                  );
                                },
                          child: Icon(
                            Icons.map_rounded,
                            color: _weather == null ? Colors.white38 : Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => context.read<ThemeProvider>().toggleTheme(),
                          child: Icon(
                            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomSearchBar(
                          onCitySelected: _loadWeatherFromCoordinates,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _loadWeatherFromLocation,
                        child: GlassContainer(
                          radius: 26,
                          blur: 12,
                          padding: const EdgeInsets.all(14),
                          child: const Icon(
                            Icons.my_location_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center, style: AppTypography.condition),
            ],
          ),
        ),
      );
    }

    final weather = _weather!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 28),
          WeatherCard(weather: weather),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Prévisions 5 jours',
              style: AppTypography.label.copyWith(fontSize: 15, color: Colors.white),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: weather.forecast.length,
              itemBuilder: (context, index) => ForecastCard(forecast: weather.forecast[index]),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}