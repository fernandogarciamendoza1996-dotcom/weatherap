// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Weather App';

  @override
  String get searchCity => 'Buscar ciudad';

  @override
  String get humidity => 'Humedad';

  @override
  String get wind => 'Viento';

  @override
  String get feelsLike => 'Sensación';

  @override
  String get precipitation => 'Precipitación';

  @override
  String get forecast => 'Pronóstico';

  @override
  String get clear => 'Despejado';

  @override
  String get partlyCloudy => 'Parcialmente nublado';

  @override
  String get fog => 'Niebla';

  @override
  String get drizzle => 'Llovizna';

  @override
  String get rain => 'Lluvia';

  @override
  String get showers => 'Chubascos';

  @override
  String get storm => 'Tormenta';

  @override
  String get unknownCondition => 'Condición desconocida';

  @override
  String get cityNotFound => 'Ciudad no encontrada';

  @override
  String get weatherError => 'No se pudo obtener el clima';

  @override
  String get searchError => 'No se pudo encontrar la ciudad';

  @override
  String get updateWeather => 'Actualizar clima';

  @override
  String get explorePlace => 'Explorar lugar';

  @override
  String get hourlyForecast => 'Pronóstico por hora';

  @override
  String get now => 'Ahora';
}
