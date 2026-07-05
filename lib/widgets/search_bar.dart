import 'dart:async';
import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../utils/constants.dart';
import 'glass_container.dart';

class CustomSearchBar extends StatefulWidget {
  /// Appelé quand l'utilisateur choisit une ville dans les suggestions
  final void Function(String cityName, double lat, double lon) onCitySelected;

  const CustomSearchBar({super.key, required this.onCitySelected});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (query.trim().length < 2) {
        setState(() => _suggestions = []);
        return;
      }
      setState(() => _isSearching = true);
      final results = await _weatherService.searchCities(query.trim());
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isSearching = false;
        });
      }
    });
  }

  void _selectCity(Map<String, dynamic> city) {
    final label = city['admin1'].toString().isNotEmpty
        ? '${city['name']}, ${city['admin1']}'
        : city['name'].toString();
    _controller.text = label;
    setState(() => _suggestions = []);
    FocusScope.of(context).unfocus();
    widget.onCitySelected(
      city['name'],
      city['latitude'],
      city['longitude'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassContainer(
          radius: 26,
          blur: 12,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            style: AppTypography.value,
            cursorColor: AppColors.textPrimary,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Rechercher une ville...',
              hintStyle: AppTypography.label,
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
              suffixIcon: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: GlassContainer(
              radius: 18,
              blur: 14,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final city = _suggestions[index];
                  final subtitle = [
                    if (city['admin1'].toString().isNotEmpty) city['admin1'],
                    city['country'],
                  ].join(', ');

                  return InkWell(
                    onTap: () => _selectCity(city),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: AppColors.textMuted, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(city['name'], style: AppTypography.value),
                                if (subtitle.isNotEmpty)
                                  Text(subtitle, style: AppTypography.label),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}