// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Weather App';

  @override
  String get searchCity => 'Rechercher une ville';

  @override
  String get humidity => 'Humidité';

  @override
  String get wind => 'Vent';

  @override
  String get feelsLike => 'Ressenti';

  @override
  String get precipitation => 'Précipitations';

  @override
  String get forecast => 'Prévisions';

  @override
  String get clear => 'Dégagé';

  @override
  String get partlyCloudy => 'Partiellement nuageux';

  @override
  String get fog => 'Brouillard';

  @override
  String get drizzle => 'Bruine';

  @override
  String get rain => 'Pluie';

  @override
  String get showers => 'Averses';

  @override
  String get storm => 'Orage';

  @override
  String get unknownCondition => 'Condition inconnue';

  @override
  String get cityNotFound => 'Ville introuvable';

  @override
  String get weatherError => 'Impossible d\'obtenir la météo';

  @override
  String get searchError => 'Impossible de trouver la ville';

  @override
  String get updateWeather => 'Actualiser la météo';

  @override
  String get explorePlace => 'Explorer le lieu';

  @override
  String get hourlyForecast => 'Prévisions horaires';

  @override
  String get now => 'Maintenant';
}
