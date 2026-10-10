
class WeatherModel {
  final double latitude;
  final double longitude;

  final double temperature;
  final int humidity;
  final double windSpeed;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;

  final List<String> forecastDates;
  final List<double> maxTemperatures;
  final List<double> minTemperatures;
  final List<int> forecastWeatherCodes;

  // Pronóstico por hora
  final List<String> hourlyTimes;
  final List<double> hourlyTemperatures;
  final List<int> hourlyPrecipitationProbabilities;
  final List<int> hourlyWeatherCodes;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.forecastDates,
    required this.maxTemperatures,
    required this.minTemperatures,
    required this.forecastWeatherCodes,
    required this.hourlyTimes,
    required this.hourlyTemperatures,
    required this.hourlyPrecipitationProbabilities,
    required this.hourlyWeatherCodes,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> data) {
    final hourly = data['hourly'];

    return WeatherModel(
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),

      temperature:
          (data['current']['temperature_2m'] as num).toDouble(),
      humidity: (data['current']['relative_humidity_2m'] as num).toInt(),
      windSpeed: (data['current']['wind_speed_10m'] as num).toDouble(),
      apparentTemperature:
          (data['current']['apparent_temperature'] as num).toDouble(),
      precipitation:
          (data['current']['precipitation'] as num).toDouble(),
      weatherCode: (data['current']['weather_code'] as num).toInt(),

      forecastDates: List<String>.from(data['daily']['time']),
      maxTemperatures: List<double>.from(
        (data['daily']['temperature_2m_max'] as List)
            .map((value) => (value as num).toDouble()),
      ),
      minTemperatures: List<double>.from(
        (data['daily']['temperature_2m_min'] as List)
            .map((value) => (value as num).toDouble()),
      ),
      forecastWeatherCodes: List<int>.from(
        (data['daily']['weather_code'] as List)
            .map((value) => (value as num).toInt()),
      ),

      // Datos horarios
      hourlyTimes: List<String>.from(hourly['time']),
      hourlyTemperatures: List<double>.from(
        (hourly['temperature_2m'] as List)
            .map((value) => (value as num).toDouble()),
      ),
      hourlyPrecipitationProbabilities: List<int>.from(
        (hourly['precipitation_probability'] as List)
            .map((value) => (value as num).toInt()),
      ),
      hourlyWeatherCodes: List<int>.from(
        (hourly['weather_code'] as List)
            .map((value) => (value as num).toInt()),
      ),
    );
  }
}