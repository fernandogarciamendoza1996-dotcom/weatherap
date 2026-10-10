import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getWeather(
    double latitude,
    double longitude,
  ) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,'
      'apparent_temperature,precipitation,weather_code'
      '&hourly=temperature_2m,precipitation_probability,weather_code'
      '&forecast_hours=24'
      '&timezone=auto'
      '&daily=temperature_2m_max,temperature_2m_min,weather_code',
    );

    final response = await http.get(url);

    

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al obtener el clima: ${response.statusCode}');
    }
  }
}