import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/weather.dart';
import '../services/radar_service.dart';
import '../utils/constants.dart';
import '../utils/theme_provider.dart';
import '../widgets/glass_container.dart';

class DetailsScreen extends StatefulWidget {
  final Weather weather;

  const DetailsScreen({super.key, required this.weather});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final RadarService _radarService = RadarService();
  final MapController _mapController = MapController();

  String? _radarTileUrl;
  bool _showRadar = true;

  @override
  void initState() {
    super.initState();
    _loadRadar();
  }

  Future<void> _loadRadar() async {
    try {
      final url = await _radarService.getLatestRadarTileUrl();
      if (mounted) setState(() => _radarTileUrl = url);
    } catch (_) {
      // Pas grave si le radar échoue, la carte reste utilisable
    }
  }

  void _zoom(double delta) {
    _mapController.move(
      _mapController.camera.center,
      _mapController.camera.zoom + delta,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final center = LatLng(widget.weather.latitude, widget.weather.longitude);

    final tileUrl = isDark
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFEAEAEA),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 8,
              minZoom: 3,
              maxZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.weather_app',
                retinaMode: true,
              ),
              if (_showRadar && _radarTileUrl != null)
                TileLayer(
                  urlTemplate: _radarTileUrl,
                  userAgentPackageName: 'com.example.weather_app',
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: 50,
                    height: 50,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.redAccent,
                      size: 44,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                    ),
                  ),
                ],
              ),
              const RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                  TextSourceAttribution('© CARTO'),
                  TextSourceAttribution('© RainViewer'),
                ],
              ),
            ],
          ),

          // Header : retour + nom de la ville + toggle radar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: GlassContainer(
                      radius: 20,
                      blur: 12,
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassContainer(
                      radius: 20,
                      blur: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(widget.weather.cityName, style: AppTypography.value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => setState(() => _showRadar = !_showRadar),
                    child: GlassContainer(
                      radius: 20,
                      blur: 12,
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        _showRadar ? Icons.layers_rounded : Icons.layers_clear_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Boutons de zoom
          Positioned(
            right: 16,
            bottom: 140,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _zoom(1),
                  child: GlassContainer(
                    radius: 14,
                    blur: 12,
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _zoom(-1),
                  child: GlassContainer(
                    radius: 14,
                    blur: 12,
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.remove_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Mini-card météo flottante en bas
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: GlassContainer(
              radius: 22,
              blur: 14,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    WeatherIconMapper.getIcon(widget.weather.weatherCode, isDay: widget.weather.isDay),
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          WeatherIconMapper.getLabel(widget.weather.weatherCode),
                          style: AppTypography.value,
                        ),
                        Text(
                          '${widget.weather.temperature.round()}° · Ressenti ${widget.weather.feelsLike.round()}°',
                          style: AppTypography.label,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}