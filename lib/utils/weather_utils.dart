import '../l10n/app_localizations.dart';

String getWeatherDescription(
  int code,
  AppLocalizations l10n,
) {
  if (code == 0) {
    return l10n.clear;
  } else if (code >= 1 && code <= 3) {
    return l10n.partlyCloudy;
  } else if (code >= 45 && code <= 48) {
    return l10n.fog;
  } else if (code >= 51 && code <= 57) {
    return l10n.drizzle;
  } else if (code >= 61 && code <= 67) {
    return l10n.rain;
  } else if (code >= 80 && code <= 82) {
    return l10n.showers;
  } else if (code >= 95 && code <= 99) {
    return l10n.storm;
  }

  return l10n.unknownCondition;
}
String getWeatherEmoji(int code) {
  if (code == 0) {
    return '☀️';
  } else if (code >= 1 && code <= 3) {
    return '🌤️';
  } else if (code >= 45 && code <= 48) {
    return '🌫️';
  } else if (code >= 51 && code <= 57) {
    return '🌦️';
  } else if (code >= 61 && code <= 67) {
    return '🌧️';
  } else if (code >= 80 && code <= 82) {
    return '🌦️';
  } else if (code >= 95 && code <= 99) {
    return '⛈️';
  }

  return '❓';
}