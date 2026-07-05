import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../utils/constants.dart';

class WeatherService {
  /// Recherche une ville et retourne ses coordonnées + nom normalisé
  Future<Map<String, dynamic>> _geocodeCity(String cityName) async {
    final uri = Uri.parse(
      '${ApiConstants.geocodingUrl}?name=${Uri.encodeComponent(cityName)}&count=1&language=fr&format=json',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erreur réseau (géocodage)');
    }

    final data = jsonDecode(response.body);
    final results = data['results'] as List?;

    if (results == null || results.isEmpty) {
      throw Exception('Ville introuvable');
    }

    final place = results[0];
    return {
      'name': place['name'],
      'latitude': place['latitude'],
      'longitude': place['longitude'],
    };
  }
    /// Recherche plusieurs villes correspondant à une requête (pour l'autocomplete)
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
      '${ApiConstants.geocodingUrl}?name=${Uri.encodeComponent(query)}&count=5&language=fr&format=json',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    final results = data['results'] as List?;
    if (results == null) return [];

    return results.map<Map<String, dynamic>>((r) => {
          'name': r['name'],
          'country': r['country'] ?? '',
          'admin1': r['admin1'] ?? '',
          'latitude': r['latitude'],
          'longitude': r['longitude'],
        }).toList();
  }
  /// Récupère la météo actuelle + prévisions 5 jours pour une ville
  Future<Weather> getWeatherByCity(String cityName) async {
    final location = await _geocodeCity(cityName);
    return _fetchWeather(
      latitude: location['latitude'],
      longitude: location['longitude'],
      cityName: location['name'],
    );
  }

  /// Récupère la météo pour des coordonnées GPS précises (position actuelle)
  Future<Weather> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
    String cityName = 'Ma position',
  }) async {
    return _fetchWeather(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
    );
  }

  Future<Weather> _fetchWeather({
    required double latitude,
    required double longitude,
    required String cityName,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}'
      '?latitude=$latitude&longitude=$longitude'
      '&current=temperature_2m,apparent_temperature,relative_humidity_2m,weathercode,wind_speed_10m,is_day'
      '&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset'
      '&timezone=auto',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Erreur réseau (météo)');
    }

    final data = jsonDecode(response.body);
    return Weather.fromOpenMeteo(data, cityName);
  }
}