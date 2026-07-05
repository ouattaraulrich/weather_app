import 'dart:convert';
import 'package:http/http.dart' as http;

class RadarService {
  static const String _apiUrl =
      'https://api.rainviewer.com/public/weather-maps.json';

  /// Retourne le template d'URL des tuiles radar (image la plus récente)
  /// Format compatible flutter_map : contient {z}/{x}/{y}
  Future<String> getLatestRadarTileUrl() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode != 200) {
      throw Exception('Impossible de charger le radar météo');
    }

    final data = jsonDecode(response.body);
    final host = data['host'] as String;
    final pastFrames = data['radar']['past'] as List;

    if (pastFrames.isEmpty) {
      throw Exception('Aucune donnée radar disponible');
    }

    final latestFrame = pastFrames.last;
    final path = latestFrame['path'] as String;

    return '$host$path/256/{z}/{x}/{y}/2/1_1.png';
  }
}
