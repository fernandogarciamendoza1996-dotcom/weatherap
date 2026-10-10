
import 'package:flutter/material.dart';

import '../utils/weather_utils.dart';
import '../l10n/app_localizations.dart';

class ForecastCard extends StatelessWidget {
  final String date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
  final bool isToday;

  const ForecastCard({
    super.key,
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
    this.isToday = false,
  });

  String _getDayName(String date, AppLocalizations l10n) {
final parsedDate = DateTime.tryParse(date);

if (parsedDate == null) return date;

final weekday = parsedDate.weekday;

switch (l10n.localeName) {
case 'en':
return [
'Monday', 'Tuesday', 'Wednesday', 'Thursday',
'Friday', 'Saturday', 'Sunday',
][weekday - 1];
case 'fr':
return [
'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
'Vendredi', 'Samedi', 'Dimanche',
][weekday - 1];
default:
return [
'Lunes', 'Martes', 'Miércoles', 'Jueves',
'Viernes', 'Sábado', 'Domingo',
][weekday - 1];
}
}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 145,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.fromLTRB(14, 17, 14, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isToday
              ? const [
                  Color(0xF01A2B50),
                  Color(0xF0121734),
                  Color(0xF01C1740),
                ]
              : const [
                  Color(0xE6121D38),
                  Color(0xE6091024),
                  Color(0xE6121630),
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isToday
              ? const Color(0xFF818CF8).withValues(alpha:0.65)
              : const Color(0xFF829DDE).withValues(alpha:0.20),
          width: isToday ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isToday
                ? const Color(0xFF6366F1).withValues(alpha:0.16)
                : Colors.black.withValues(alpha:0.16),
            blurRadius: isToday ? 24 : 15,
            spreadRadius: isToday ? 1 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
children: [
Text(
isToday ? l10n.forecast : _getDayName(date, l10n),
maxLines: 1,
overflow: TextOverflow.ellipsis,
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 14,
fontWeight: FontWeight.w700,
color: isToday
? const Color(0xFFC4B5FD)
: const Color(0xFFD5DFF5),
),
),
if (!isToday) ...[
const SizedBox(height: 4),
Text(
date,
style: const TextStyle(
fontSize: 11,
color: Color(0xFF829DDE),
),
),
],
],
),
          const SizedBox(height: 13),

          // Icono meteorológico
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isToday
                    ? const [
                        Color(0xFF293D6A),
                        Color(0xFF171D3C),
                      ]
                    : const [
                        Color(0xFF1D2947),
                        Color(0xFF11182D),
                      ],
              ),
              border: Border.all(
                color: isToday
                    ? const Color(0xFF818CF8).withValues(alpha:0.32)
                    : Colors.white.withValues(alpha:0.08),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              getWeatherEmoji(weatherCode),
              style: const TextStyle(fontSize: 34),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            getWeatherDescription(weatherCode, l10n),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFA9B9D8),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFF829DDE).withValues(alpha:0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 11),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_upward_rounded,
                size: 15,
                color: const Color(0xFFFFAD91),
              ),
              const SizedBox(width: 2),
              Text(
                '${maxTemperature.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFAD91),
                ),
              ),
              const SizedBox(width: 9),
              Icon(
                Icons.arrow_downward_rounded,
                size: 15,
                color: const Color(0xFF7DD3FC),
              ),
              const SizedBox(width: 2),
              Text(
                '${minTemperature.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF7DD3FC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

