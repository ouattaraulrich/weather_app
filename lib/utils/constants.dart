import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Couleurs de base utilisées sur le fond dégradé (glassmorphism)
class AppColors {
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xCCFFFFFF); // blanc 80%
  static const Color textMuted = Color(0x99FFFFFF); // blanc 60%

  static Color glassFill(bool isDark) =>
      isDark ? const Color(0x59000000) : const Color(0x33FFFFFF);

  static Color glassBorder(bool isDark) =>
      isDark ? const Color(0x33FFFFFF) : const Color(0x4DFFFFFF);

  static Color overlay(bool isDark) =>
      isDark ? const Color(0x66000000) : Colors.transparent;
}

/// Génère le dégradé de fond selon le code météo (Open-Meteo) et l'heure
class WeatherGradients {
  static LinearGradient getGradient(int weatherCode, {required bool isDay}) {
    if (!isDay) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      );
    }
    if (weatherCode <= 1) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A90E2), Color(0xFF87CEEB), Color(0xFFFFD980)],
      );
    }
    if (weatherCode <= 3) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6B8DBA), Color(0xFF8FA3C4), Color(0xFFB8C6D9)],
      );
    }
    if (weatherCode == 45 || weatherCode == 48) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF757F9A), Color(0xFFD7DDE8)],
      );
    }
    if ((weatherCode >= 51 && weatherCode <= 67) ||
        (weatherCode >= 80 && weatherCode <= 82)) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3A6073), Color(0xFF16222A), Color(0xFF3A6073)],
      );
    }
    if ((weatherCode >= 71 && weatherCode <= 77) ||
        (weatherCode >= 85 && weatherCode <= 86)) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF83A4D4), Color(0xFFB6FBFF)],
      );
    }
    if (weatherCode >= 95) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF232526), Color(0xFF414345)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
    );
  }
}

/// Typographie (Poppins pour les titres, Inter pour le texte courant)
class AppTypography {
  static TextStyle temperature = GoogleFonts.poppins(
    fontSize: 72,
    fontWeight: FontWeight.w200,
    color: AppColors.textPrimary,
  );

  static TextStyle cityName = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle condition = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
  );

  static TextStyle value = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle forecastDay = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

/// Mapping du weathercode Open-Meteo vers une icône Material et un libellé FR
class WeatherIconMapper {
  static IconData getIcon(int weatherCode, {required bool isDay}) {
    if (weatherCode <= 1) {
      return isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round;
    }
    if (weatherCode == 2) {
      return isDay ? Icons.wb_cloudy_rounded : Icons.cloud_rounded;
    }
    if (weatherCode == 3) return Icons.cloud_rounded;
    if (weatherCode == 45 || weatherCode == 48) return Icons.foggy;
    if (weatherCode >= 51 && weatherCode <= 57) return Icons.grain_rounded;
    if (weatherCode >= 61 && weatherCode <= 67) {
      return Icons.water_drop_rounded;
    }
    if (weatherCode >= 71 && weatherCode <= 77) return Icons.ac_unit_rounded;
    if (weatherCode >= 80 && weatherCode <= 82) return Icons.grain_rounded;
    if (weatherCode >= 85 && weatherCode <= 86) return Icons.ac_unit_rounded;
    if (weatherCode >= 95) return Icons.thunderstorm_rounded;
    return Icons.wb_sunny_rounded;
  }

  static String getLabel(int weatherCode) {
    if (weatherCode <= 1) return 'Ensoleillé';
    if (weatherCode <= 3) return 'Nuageux';
    if (weatherCode == 45 || weatherCode == 48) return 'Brouillard';
    if (weatherCode >= 51 && weatherCode <= 57) return 'Bruine';
    if (weatherCode >= 61 && weatherCode <= 67) return 'Pluie';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Neige';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Averses';
    if (weatherCode >= 85 && weatherCode <= 86) return 'Averses de neige';
    if (weatherCode >= 95) return 'Orage';
    return 'Ensoleillé';
  }
}

/// URLs API Open-Meteo
class ApiConstants {
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String geocodingUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
}