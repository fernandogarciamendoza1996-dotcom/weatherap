// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weather App';

  @override
  String get searchCity => 'Search city';

  @override
  String get humidity => 'Humidity';

  @override
  String get wind => 'Wind';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get forecast => 'Forecast';

  @override
  String get clear => 'Clear';

  @override
  String get partlyCloudy => 'Partly cloudy';

  @override
  String get fog => 'Fog';

  @override
  String get drizzle => 'Drizzle';

  @override
  String get rain => 'Rain';

  @override
  String get showers => 'Showers';

  @override
  String get storm => 'Thunderstorm';

  @override
  String get unknownCondition => 'Unknown condition';

  @override
  String get cityNotFound => 'City not found';

  @override
  String get weatherError => 'Could not get weather';

  @override
  String get searchError => 'Could not find the city';

  @override
  String get updateWeather => 'Update weather';

  @override
  String get explorePlace => 'Explore place';

  @override
  String get hourlyForecast => 'Hourly Forecast';

  @override
  String get now => 'Now';
}
