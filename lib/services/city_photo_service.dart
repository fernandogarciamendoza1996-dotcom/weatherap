import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CityPhotoService {
  static const String _baseUrl = 'https://commons.wikimedia.org/w/api.php';

  Future<String?> searchCityPhoto({
    required String city,
    String? country,
  }) async {
    final cityName = city.trim();
    final countryName = country?.trim() ?? '';

    if (cityName.isEmpty) return null;

    final queries = <String>[
      if (countryName.isNotEmpty) 'intitle:"$cityName" "$countryName" landmark',
      if (countryName.isNotEmpty) 'intitle:"$cityName" "$countryName" city',
      if (countryName.isNotEmpty) '"$cityName" "$countryName" skyline',
      if (countryName.isNotEmpty) '"$cityName" "$countryName" aerial',
      if (countryName.isNotEmpty) '"$cityName" "$countryName" panorama',
      'intitle:"$cityName" skyline',
      'intitle:"$cityName" city',
    ];

    String? bestPhotoUrl;
    int bestScore = -999;

    for (final query in queries) {
      final result = await _search(query, cityName, countryName);

      if (result != null && result.score > bestScore) {
        bestScore = result.score;
        bestPhotoUrl = result.url;
      }
    }

    if (bestPhotoUrl != null && bestScore >= 7) {
      debugPrint(
        'Mejor imagen global: $bestPhotoUrl '
        '(puntuación: $bestScore)',
      );
      return bestPhotoUrl;
    }

    debugPrint(
      'Wikimedia Commons no encontró una imagen adecuada '
      'para $cityName. Mejor puntuación: $bestScore',
    );

    return null;
  }

  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n')
        .trim();
  }

 int _scorePhoto({
  required String title,
  required String description,
  required String objectName,
  required String categories,
  required String city,
}) {
  final normalizedTitle = _normalizeText(
    title.replaceAll('_', ' ').replaceAll('-', ' '),
  );

  final text = _normalizeText(
    '$normalizedTitle $description $objectName $categories',
  );

  final normalizedCity = _normalizeText(
    city.replaceAll('_', ' '),
  );

  var score = 0;

  // Priorizar que el nombre del archivo identifique la ciudad.
  if (normalizedTitle.contains(normalizedCity)) {
    score += 5;
  } else if (text.contains(normalizedCity)) {
    score += 2;
  }

  // Términos que indican una vista real de la ciudad.
  const strongPositiveTerms = [
    'cityscape',
    'cityscapes',
    'skyline',
    'skylines',
    'aerial view',
    'aerial photo',
    'aerial photograph',
    'aerial photographs',
    'vista aerea',
    'fotografia aerea',
    'panorama of',
    'panoramica de',
    'panoramicas in',
    'panoramics in',
    'panoramas of',
    'city from above',
    'urban landscape',
    'horizonte urbano',
    'vista del horizonte',
    'vista de la ciudad',
    'views of',
  ];

  for (final term in strongPositiveTerms) {
    if (text.contains(term)) {
      score += 6;
    }
  }

  // Favorecer categorías específicas de paisajes urbanos.
  if (text.contains('cityscapes of $normalizedCity')) {
    score += 5;
  }

  if (text.contains('skylines of $normalizedCity')) {
    score += 5;
  }

  if (text.contains('aerial photographs of $normalizedCity')) {
    score += 5;
  }

  // Penalizar mapas, logotipos, dibujos y composiciones.
  const negativeTerms = [
    'collage',
    'montage',
    'coat of arms',
    'escudo de armas',
    'logo',
    'logos',
    'textlogo',
    'locator map',
    'location map',
    'map of',
    'maps of',
    'historical map',
    'old maps',
    'drawing of',
    'drawings of',
    'illustration',
    'illustrations',
    'engraving',
    'caricature',
    'caricatures',
    'painting',
    'paintings',
    'church interior',
    'museum interior',
    'interior of',
    'group photo',
    'political rally',
    'press conference',
  ];

  for (final term in negativeTerms) {
    if (text.contains(term)) {
      score -= 12;
    }
  }

  // Penalizar fotografías antiguas cuando el contexto indica
  // claramente que no representan la ciudad actual.
  const historicalTerms = [
    '19th century',
    '18th century',
    '17th century',
    'historical illustration',
    'historic illustration',
    'historical caricature',
    'old postcard',
    'historical postcard',
    'in 1869',
    'in 1909',
    'in 1922',
  ];

  for (final term in historicalTerms) {
    if (text.contains(term)) {
      score -= 8;
    }
  }

  // Un edificio o puente aislado no debe ganar automáticamente
  // frente a una buena vista panorámica.
  const weakLandmarkTerms = [
    'bridge',
    'tower',
    'historic building',
    'palace',
    'city hall',
  ];

  for (final term in weakLandmarkTerms) {
    if (text.contains(term)) {
      score += 1;
    }
  }

  return score;
}

  Future<({String url, int score})?> _search(
    String query,
    String cityName,
    String countryName,
  ) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'action': 'query',
        'format': 'json',
        'generator': 'search',
        'gsrsearch': query,
        'gsrnamespace': '6',
        'gsrlimit': '10',
        'prop': 'imageinfo',
        'iiprop': 'url|mime|extmetadata',
        'iiextmetadatafilter': 'ImageDescription|ObjectName|Categories',
        'iiurlwidth': '1000',
        'origin': '*',
      },
    );

    try {
      debugPrint('Buscando en Wikimedia Commons: $query');

      final response = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'WeatherAp/1.0 (Flutter app)',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        debugPrint('Wikimedia error: ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final pages = data['query']?['pages'] as Map<String, dynamic>?;

      if (pages == null || pages.isEmpty) {
        debugPrint('No hay resultados para: $query');
        return null;
      }

      final normalizedCity = _normalizeText(cityName.replaceAll('_', ' '));

      final normalizedCountry = _normalizeText(countryName);

      String cleanText(String value) {
        return _normalizeText(value.replaceAll('_', ' ').replaceAll('-', ' '));
      }

      String? bestPhotoUrl;
      int bestScore = -999;

      for (final page in pages.values) {
        if (page is! Map<String, dynamic>) continue;

        final title = page['title'] as String? ?? '';
        final imageInfo = page['imageinfo'];

        if (imageInfo is! List || imageInfo.isEmpty) {
          continue;
        }

        final info = imageInfo.first;

        if (info is! Map<String, dynamic>) continue;

        final mime = info['mime'] as String? ?? '';

        if (!mime.startsWith('image/')) continue;

        final metadata = info['extmetadata'] as Map<String, dynamic>? ?? {};

        String getMetadata(String key) {
          final value = metadata[key];

          if (value is Map<String, dynamic>) {
            return (value['value'] as String? ?? '').replaceAll(
              RegExp(r'<[^>]*>'),
              ' ',
            );
          }

          return '';
        }

        final description = getMetadata('ImageDescription');
        final objectName = getMetadata('ObjectName');
        final categories = getMetadata('Categories');

        final normalizedTitle = cleanText(title);
        final normalizedDescription = cleanText(description);
        final normalizedObjectName = cleanText(objectName);
        final normalizedCategories = cleanText(categories);

        final searchableText = cleanText(
          '$normalizedTitle $normalizedDescription '
          '$normalizedObjectName $normalizedCategories',
        );

        // La ciudad debe aparecer completa en un campo
        // relevante. No basta con encontrar palabras sueltas.
        final cityInTitle = normalizedTitle.contains(normalizedCity);

        final cityInDescription = normalizedDescription.contains(
          normalizedCity,
        );

        final cityInObjectName = normalizedObjectName.contains(normalizedCity);

        final cityInRelevantCategory =
            normalizedCategories.contains('views of $normalizedCity') ||
            normalizedCategories.contains('view of $normalizedCity') ||
            normalizedCategories.contains('skyline of $normalizedCity') ||
            normalizedCategories.contains('skylines of $normalizedCity') ||
            normalizedCategories.contains('panoramas of $normalizedCity') ||
            normalizedCategories.contains('panoramics in $normalizedCity') ||
            normalizedCategories.contains('cityscapes of $normalizedCity') ||
            normalizedCategories.contains(
              'aerial photographs of $normalizedCity',
            );

        final mentionsCity =
            cityInTitle ||
            cityInDescription ||
            cityInObjectName ||
            cityInRelevantCategory;

        // El país ayuda a validar la ubicación, pero no
        // sustituye la coincidencia con la ciudad.
        final mentionsCountry =
            normalizedCountry.isEmpty ||
            searchableText.contains(normalizedCountry);

        // Protección para evitar monumentos de España
        // confundidos con San Salvador, El Salvador.
        final contradictoryCountry =
            normalizedCountry == 'el salvador' &&
            (searchableText.contains('spain') ||
                searchableText.contains('espana') ||
                searchableText.contains('la roda'));

        final clearlyBelongsToCity =
            searchableText.contains('$normalizedCity skyline') ||
            searchableText.contains('skyline of $normalizedCity') ||
            searchableText.contains('skylines of $normalizedCity') ||
            searchableText.contains('views of $normalizedCity') ||
            searchableText.contains('view of $normalizedCity') ||
            searchableText.contains('panorama of $normalizedCity') ||
            searchableText.contains('panoramas of $normalizedCity') ||
            searchableText.contains('cityscape of $normalizedCity') ||
            searchableText.contains('aerial view of $normalizedCity') ||
            searchableText.contains('aerial photographs of $normalizedCity') ||
            searchableText.contains('landscape of $normalizedCity');

        final validLocation =
            !contradictoryCountry && (mentionsCountry || clearlyBelongsToCity);

        debugPrint('Archivo: $title');
        debugPrint('Descripción: $description');
        debugPrint('Nombre del objeto: $objectName');
        debugPrint('Categorías: $categories');
        debugPrint('¿Coincide con la ciudad?: $mentionsCity');
        debugPrint('¿Coincide con el país?: $mentionsCountry');
        debugPrint('¿País contradictorio?: $contradictoryCountry');
        debugPrint('¿La ubicación parece válida?: $validLocation');

        if (!mentionsCity || !validLocation) continue;

        final thumbUrl = info['thumburl'];
        final originalUrl = info['url'];

        final photoUrl = thumbUrl is String && thumbUrl.startsWith('https://')
            ? thumbUrl
            : originalUrl is String && originalUrl.startsWith('https://')
            ? originalUrl
            : null;

        if (photoUrl == null) continue;

        final score = _scorePhoto(
          title: title,
          description: description,
          objectName: objectName,
          categories: categories,
          city: cityName,
        );

        debugPrint('Puntuación de $title: $score');

        if (score > bestScore) {
          bestScore = score;
          bestPhotoUrl = photoUrl;
        }
      }

      if (bestPhotoUrl != null && bestScore >= 7) {
        debugPrint(
          'Mejor imagen de esta búsqueda: $bestPhotoUrl '
          '(puntuación: $bestScore)',
        );

        return (url: bestPhotoUrl, score: bestScore);
      }

      debugPrint(
        'No se encontró una imagen suficientemente relevante. '
        'Mejor puntuación: $bestScore',
      );

      return null;
    } catch (e) {
      debugPrint('Error consultando Wikimedia: $e');
      return null;
    }
  }
}
