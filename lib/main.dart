
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'screens/weather_home_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Locale _locale = const Locale('es');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      title: 'Weather App',

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: WeatherHomePage(
  onLanguageChanged: changeLanguage,
),
    );
  }
}

