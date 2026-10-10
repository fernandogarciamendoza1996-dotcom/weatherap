
import 'dart:convert';

import 'package:http/http.dart' as http;

class GeocodingService {
  Future<List<Map<String, dynamic>>> searchCities(String city) async {
    final cityName = city.trim();

    if (cityName.isEmpty) {
      return [];
    }

    final url = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      {
        'name': cityName,
        'count': '5',
        'language': 'es',
        'format': 'json',
      },
    );

    final response = await http
        .get(url)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Error buscando ciudades');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'];

    if (results is List) {
      return List<Map<String, dynamic>>.from(results);
    }

    return [];
  }
}