import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Vérifie les permissions et retourne la position actuelle.
  /// Lève une exception avec un message clair si ce n'est pas possible.
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Active la localisation dans les paramètres de ton téléphone.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permission de localisation refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permission refusée définitivement. Active-la manuellement dans les paramètres.',
      );
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }
}