import '../services/city_photo_service.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/animated_weather_background.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/geocoding_service.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_info_card.dart';
import '../widgets/forecast_card.dart';
import '../models/weather_model.dart';
import '../widgets/weather_map.dart';
import '../l10n/app_localizations.dart';
import '../widgets/city_photo_card.dart';
class WeatherHomePage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;

  const WeatherHomePage({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String cityName = 'San Lorenzo';
String countryName = 'Honduras';
  double currentLatitude = 13.3;
  double currentLongitude = -87.6;


  
  final WeatherService weatherService = WeatherService();
  final GeocodingService geocodingService = GeocodingService();
  final TextEditingController cityController = TextEditingController();
  final CityPhotoService cityPhotoService = CityPhotoService();

 
  
WeatherModel? weather;

  bool loading = true;
  String? error;
  List<Map<String, dynamic>> citySuggestions = [];
  Timer? _debounce;
  String? cityPhotoUrl;
  bool loadingCityPhoto = false;

 
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    loadWeather();

    loadCityPhoto(
      city: cityName,
      country: countryName,
    );
  });
}


Future<void> loadWeather() async {
  setState(() {
    loading = true;
    error = null;
  });

  try {
    final data = await weatherService.getWeather(
      currentLatitude,
      currentLongitude,
    );

    final newWeather = WeatherModel.fromJson(data);

    if (!mounted) return;

    setState(() {
      weather = newWeather;
      loading = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      error = 'No se pudo obtener el clima';
      loading = false;
    });
  }
}

Future<void> loadCityPhoto({
  required String city,
  required String country,
}) async {
  setState(() {
    loadingCityPhoto = true;
    cityPhotoUrl = null;
  });

  final photo = await cityPhotoService.searchCityPhoto(
    city: city,
    country: country,
  );

  if (!mounted) return;

  setState(() {
    cityPhotoUrl = photo;
    loadingCityPhoto = false;
  });
}



Future<void> searchCity() async {
  final l10n = AppLocalizations.of(context)!;
  final city = cityController.text.trim();

  if (city.isEmpty) return;

  setState(() {
    loading = true;
    error = null;
    citySuggestions = [];
  });

  try {
    final cities = await geocodingService.searchCities(city);

    if (!mounted) return;

    if (cities.isEmpty) {
      throw Exception(l10n.cityNotFound);
    }

    // Si se busca con Enter, usa el primer resultado.
    await selectCity(cities.first);
  } catch (e) {
    if (!mounted) return;

    setState(() {
      error = l10n.searchError;
      loading = false;
    });
  }
}

Future<void> selectCity(Map<String, dynamic> location) async {
  if (!mounted) return;

  setState(() {
    loading = true;
    error = null;
    citySuggestions = [];
  });

  try {
    final newCityName = location['name'] as String;
    final newCountryName = location['country'] as String;
    final latitude = (location['latitude'] as num).toDouble();
    final longitude = (location['longitude'] as num).toDouble();

    final data = await weatherService.getWeather(
      latitude,
      longitude,
    );

    final newWeather = WeatherModel.fromJson(data);

    if (!mounted) return;

    setState(() {
      cityName = newCityName;
      countryName = newCountryName;
      currentLatitude = latitude;
      currentLongitude = longitude;
      weather = newWeather;
      loading = false;
      cityController.text = newCityName;
    });

    await loadCityPhoto(
      city: newCityName,
      country: newCountryName,
    );
  } catch (e) {
    if (!mounted) return;

    setState(() {
      error = AppLocalizations.of(context)!.searchError;
      loading = false;
    });
  }
}


@override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

Future<void> getCitySuggestions(String query) async {
  _debounce?.cancel();

  if (query.trim().length < 3) {
    setState(() {
      citySuggestions = [];
    });
    return;
  }

  _debounce = Timer(
    const Duration(milliseconds: 400),
    () async {
      try {
        final cities = await geocodingService.searchCities(
          query.trim(),
        );

        if (!mounted) return;

        setState(() {
          citySuggestions = cities;
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          citySuggestions = [];
        });
      }
    },
  );
}
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(

appBar: AppBar(
  backgroundColor: Color(0xFF1565C0),
  elevation: 0,
  surfaceTintColor: Colors.transparent,

  title: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.cloud,
          color: Colors.white,
          size: 23,
        ),
      ),

      const SizedBox(width: 10),

      Text(
        l10n.appTitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),

  centerTitle: true,

  actions: [
    PopupMenuButton<String>(
      icon: const Icon(
        Icons.language,
        color: Colors.white,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      onSelected: (language) {
        switch (language) {
          case 'es':
            widget.onLanguageChanged(
              const Locale('es'),
            );
            break;

          case 'en':
            widget.onLanguageChanged(
              const Locale('en'),
            );
            break;

          case 'fr':
            widget.onLanguageChanged(
              const Locale('fr'),
            );
            break;
        }
      },

      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'es',
          child: Row(
            children: [
              Text('🇪🇸'),
              SizedBox(width: 10),
              Text('Español'),
            ],
          ),
        ),

        const PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              Text('🇺🇸'),
              SizedBox(width: 10),
              Text('English'),
            ],
          ),
        ),

        const PopupMenuItem(
          value: 'fr',
          child: Row(
            children: [
              Text('🇫🇷'),
              SizedBox(width: 10),
              Text('Français'),
            ],
          ),
        ),
      ],
    ),

    IconButton(
      onPressed: loadWeather,
      tooltip: l10n.updateWeather,
      icon: const Icon(
        Icons.refresh_rounded,
        color: Colors.white,
      ),
    ),

    const SizedBox(width: 4),
  ],
),




      
 body: AnimatedWeatherBackground(
  child: SafeArea(
    child: loading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : error != null
            ? Center(
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // BUSCADOR
Container(
  decoration: BoxDecoration(
    color: Colors.white.withValues(alpha:0.18),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: Colors.white.withValues(alpha:0.20),
    ),
  ),
  child: TextField(
    controller: cityController,
    onChanged: getCitySuggestions,
    onSubmitted: (_) => searchCity(),
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    decoration: InputDecoration(
      hintText: l10n.searchCity,
      hintStyle: const TextStyle(
        color: Colors.white70,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
      suffixIcon: IconButton(
        onPressed: searchCity,
        icon: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
      ),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 17,
      ),
    ),
  ),
),

// SUGERENCIAS

if (citySuggestions.isNotEmpty)
  Container(
    margin: const EdgeInsets.only(top: 10),
    constraints: const BoxConstraints(
      maxHeight: 250,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        colors: [
          Color(0xF0233157),
          Color(0xF010182F),
          Color(0xF00B1025),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: const Color(0xFF8193FF).withValues(alpha:0.45),
        width: 1.1,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6366F1).withValues(alpha:0.18),
          blurRadius: 18,
          spreadRadius: 1,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: citySuggestions.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: 58,
          endIndent: 14,
          color: const Color(0xFF8193FF).withValues(alpha:0.18),
        ),
        itemBuilder: (context, index) {
          final city = citySuggestions[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 2,
            ),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF384C85),
                    Color(0xFF222B50),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color(0xFF8B9BFF)
                      .withValues(alpha:0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1)
                        .withValues(alpha:0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Color(0xFFC4B5FD),
                size: 22,
              ),
            ),
            title: Text(
              city['name'] ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFF1F5FF),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              city['country'] ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF9DB4E8),
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF829DDE),
              size: 15,
            ),
            onTap: () {
            selectCity(city);
              },
          );
        },
      ),
    ),
  ),

CityPhotoCard(
  imageUrl: cityPhotoUrl,
  cityName: cityName,
  countryName: countryName,
  loading: loadingCityPhoto,
),

const SizedBox(height: 20),

                    // CLIMA PRINCIPAL
Container(
  width: double.infinity,
  padding: const EdgeInsets.fromLTRB(24, 26, 24, 30),
  decoration: BoxDecoration(
    color: Colors.white.withValues(alpha:0.12),
    borderRadius: BorderRadius.circular(32),
    border: Border.all(
      color: Colors.white.withValues(alpha:0.18),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha:0.12),
        blurRadius: 30,
        offset: const Offset(0, 12),
      ),
    ],
  ),
  child: Column(
    children: [
      // UBICACIÓN
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 9),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cityName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  countryName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 24),

      // ICONO DEL CLIMA
      Text(
        getWeatherEmoji(weather!.weatherCode),
        style: const TextStyle(
          fontSize: 92,
        ),
      ),

      const SizedBox(height: 4),

      // TEMPERATURA
      Text(
        '${weather!.temperature.toStringAsFixed(1)}°',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 72,
          fontWeight: FontWeight.w300,
          height: 1,
          letterSpacing: -2,
        ),
      ),

      const SizedBox(height: 12),

      // CONDICIÓN
      Text(
        getWeatherDescription(
          weather!.weatherCode,
          l10n,
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 6),

      // SENSACIÓN
      Text(
        '${l10n.feelsLike}: ${weather!.apparentTemperature.toStringAsFixed(1)}°C',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    ],
  ),
),

const SizedBox(height: 20),
                    

                   
                   // PRONÓSTICO POR HORA
HourlyForecastCard(
  weather: weather!,
),

const SizedBox(height: 24),

WeatherInfoCard(
  firstIcon: Icons.water_drop,
  firstValue: '${weather!.humidity}%',
  firstLabel: l10n.humidity,
  secondIcon: Icons.air,
  secondValue: '${weather!.windSpeed.toStringAsFixed(1)} km/h',
  secondLabel: l10n.wind,
  firstIconColor: Colors.blue,
  secondIconColor: Colors.teal,
),



                    const SizedBox(height: 20),
                    

                    //========== SENSACIÓN Y PRECIPITACIÓN ==========
                   WeatherInfoCard(
  firstIcon: Icons.thermostat,
  firstValue: '${weather!.apparentTemperature.toStringAsFixed(1)}°C',
  firstLabel: l10n.feelsLike,
  secondIcon: Icons.grain,
  secondValue: '${weather!.precipitation.toStringAsFixed(1)} mm',
  secondLabel: l10n.precipitation,
  firstIconColor: Colors.orange,
  secondIconColor: Colors.indigo,
),
WeatherMap(
  latitude: weather!.latitude,
  longitude: weather!.longitude,
),

                    const SizedBox(height: 30),

                    //================ PRONÓSTICO ===================
                  
Align(
  alignment: Alignment.centerLeft,
  child: Row(
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.14),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha:0.18),
          ),
        ),
        child: const Icon(
          Icons.calendar_month_rounded,
          color: Colors.white,
          size: 21,
        ),
      ),
      const SizedBox(width: 12),
      Text(
        l10n.forecast,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
    ],
  ),
),
const SizedBox(height: 16),


                   
const SizedBox(height: 16),

SizedBox(
  height: 245,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.only(
      right: 8,
    ),
    itemCount: weather!.forecastDates.length,
    separatorBuilder: (_, _) => const SizedBox(width: 4),
    itemBuilder: (context, index) {
      return ForecastCard(
        date: weather!.forecastDates[index],
        weatherCode: weather!.forecastWeatherCodes[index],
        maxTemperature: weather!.maxTemperatures[index],
        minTemperature: weather!.minTemperatures[index],
        isToday: index == 0,
      );
    },
  ),
),

const SizedBox(height: 30),


                    const SizedBox(height: 30),

                //============= BOTÓN ACTUALIZAR ================
SizedBox(
  width: double.infinity,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF283D70),
          Color(0xFF171F42),
          Color(0xFF11172E),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(
        color: const Color(0xFF8193FF).withValues(alpha:0.55),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6366F1).withValues(alpha:0.22),
          blurRadius: 18,
          spreadRadius: 1,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ElevatedButton.icon(
      onPressed: loadWeather,
      icon: const Icon(
        Icons.refresh_rounded,
        size: 23,
      ),
      label: Text(
        l10n.updateWeather,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFFE0E7FF),
        shadowColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    ),
  ),
),



                    const SizedBox(height: 20),
                  ],
                ),
              ),
  ),
),
    );
  }
}