import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: WeatherGradients.getGradient(1, isDay: true),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  'assets/icon/icon.png',
                  width: 140,
                  height: 140,
                ),
                const SizedBox(height: 28),
                Text(
                  'Weather App',
                  style: AppTypography.cityName.copyWith(fontSize: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Consulte la météo en temps réel,\noù que tu sois dans le monde.',
                  textAlign: TextAlign.center,
                  style: AppTypography.condition,
                ),
                const SizedBox(height: 40),
                _FeatureRow(
                  icon: Icons.search_rounded,
                  text: 'Recherche n\'importe quelle ville',
                ),
                const SizedBox(height: 18),
                _FeatureRow(
                  icon: Icons.my_location_rounded,
                  text: 'Météo instantanée à ta position',
                ),
                const SizedBox(height: 18),
                _FeatureRow(
                  icon: Icons.calendar_month_rounded,
                  text: 'Prévisions sur 5 jours',
                ),
                const SizedBox(height: 18),
                _FeatureRow(
                  icon: Icons.map_rounded,
                  text: 'Carte météo avec radar pluie',
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A90E2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Commencer',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text, style: AppTypography.value.copyWith(fontSize: 14)),
        ),
      ],
    );
  }
}