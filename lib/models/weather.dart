class Weather {
  final String cityName;
  final double latitude;
  final double longitude;
  final double temperature;
  final double feelsLike;
  final int weatherCode;
  final double windSpeed;
  final int humidity;
  final DateTime sunrise;
  final DateTime sunset;
  final bool isDay;
  final List<DailyForecast> forecast;

  Weather({
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.weatherCode,
    required this.windSpeed,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
    required this.isDay,
    required this.forecast,
  });

  factory Weather.fromOpenMeteo(Map<String, dynamic> json, String cityName) {
    final current = json['current'];
    final daily = json['daily'];

    List<DailyForecast> forecastList = [];
    final dates = daily['time'] as List;
    for (int i = 0; i < dates.length; i++) {
      forecastList.add(DailyForecast(
        date: DateTime.parse(dates[i]),
        maxTemp: (daily['temperature_2m_max'][i] as num).toDouble(),
        minTemp: (daily['temperature_2m_min'][i] as num).toDouble(),
        weatherCode: daily['weathercode'][i] as int,
      ));
    }

    return Weather(
      cityName: cityName,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      weatherCode: current['weathercode'] as int,
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      sunrise: DateTime.parse(daily['sunrise'][0]),
      sunset: DateTime.parse(daily['sunset'][0]),
      isDay: current['is_day'] == 1,
      forecast: forecastList,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });
}