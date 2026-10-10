
import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../l10n/app_localizations.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final int weatherCode;

  const AnimatedWeatherIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.weatherCode,
  });

  @override
  State<AnimatedWeatherIcon> createState() =>
      _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.92,
      end: 1.12,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotation = Tween<double>(
      begin: -0.06,
      end: 0.06,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRainy = [
      51, 53, 55, 56, 57, 61, 63, 65,
      66, 67, 80, 81, 82, 95, 96, 99,
    ].contains(widget.weatherCode);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            isRainy ? 2 * _scale.value : -3 * _scale.value,
          ),
          child: Transform.rotate(
            angle: isRainy ? 0 : _rotation.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Icon(
                widget.icon,
                color: widget.color,
                size: 34,
                shadows: [
                  Shadow(
                    color: widget.color.withValues(alpha: 0.65),
                    blurRadius: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HourlyForecastCard extends StatelessWidget {
  final WeatherModel weather;

  const HourlyForecastCard({
    super.key,
    required this.weather,
  });

  IconData _weatherIcon(int code, int hour) {
    if (code == 0) {
      return hour >= 6 && hour < 18
          ? Icons.wb_sunny_rounded
          : Icons.nightlight_round;
    }

    if ([1, 2].contains(code)) {
      return Icons.cloud_queue_rounded;
    }

    if (code == 3) {
      return Icons.cloud_rounded;
    }

    if ([45, 48].contains(code)) {
      return Icons.foggy;
    }

    if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82]
        .contains(code)) {
      return Icons.water_drop_rounded;
    }

    if ([71, 73, 75, 77, 85, 86].contains(code)) {
      return Icons.ac_unit_rounded;
    }

    if ([95, 96, 99].contains(code)) {
      return Icons.thunderstorm_rounded;
    }

    return Icons.cloud_rounded;
  }
Color _weatherColor(int code, int hour) {
  if (code == 0) {
    return hour >= 6 && hour < 18
        ? const Color(0xFFFFD43B) // Amarillo solar
        : const Color(0xFFC4B5FD); // Lavanda nocturna
  }

  if ([1, 2].contains(code)) {
    return const Color(0xFFFFB86B); // Naranja
  }

  if (code == 3) {
    return const Color(0xFFCBD5E1); // Gris claro
  }

  if ([45, 48].contains(code)) {
    return const Color(0xFFB8C0CC); // Niebla
  }

  if ([51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82]
      .contains(code)) {
    return const Color(0xFF38BDF8); // Azul celeste brillante
  }

  if ([71, 73, 75, 77, 85, 86].contains(code)) {
    return const Color(0xFF67E8F9); // Cian hielo
  }

  if ([95, 96, 99].contains(code)) {
    return const Color(0xFFE879F9); // Magenta eléctrico
  }

  return const Color(0xFFC4B5FD);
}
  String _formatHour(String time) {
    final dateTime = DateTime.tryParse(time);

    if (dateTime == null) return time;

    final hour = dateTime.hour.toString().padLeft(2, '0');
    return '$hour:00';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Encuentra la hora actual o la siguiente disponible.
    int startIndex = weather.hourlyTimes.indexWhere((time) {
      final dateTime = DateTime.tryParse(time);
      return dateTime != null &&
          !dateTime.isBefore(now) &&
          dateTime.hour == now.hour &&
          dateTime.day == now.day;
    });

    if (startIndex == -1) {
      startIndex = weather.hourlyTimes.indexWhere((time) {
        final dateTime = DateTime.tryParse(time);
        return dateTime != null && !dateTime.isBefore(now);
      });
    }

    if (startIndex == -1) return const SizedBox.shrink();

    final endIndex = (startIndex + 12 < weather.hourlyTimes.length)
        ? startIndex + 12
        : weather.hourlyTimes.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Padding(
  padding: const EdgeInsets.only(left: 4, bottom: 14),
  child: Row(
    children: [
      const Icon(
        Icons.schedule_rounded,
        color: Color(0xFFC4B5FD),
        size: 22,
      ),
      const SizedBox(width: 9),
      Text(
        AppLocalizations.of(context)!.hourlyForecast,
        style: const TextStyle(
          color: Color(0xFFF1F5FF),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  ),
),
        SizedBox(
          height: 174,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: endIndex - startIndex,
            separatorBuilder: (_, _) => const SizedBox(width: 11),
            itemBuilder: (context, index) {
              final i = startIndex + index;
              final time = DateTime.tryParse(weather.hourlyTimes[i]);
              final isCurrentHour = index == 0;

              return Container(
                width: 100,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isCurrentHour
                        ? const [
                            Color(0xFF354B85),
                            Color(0xFF202A51),
                            Color(0xFF151B36),
                          ]
                        : const [
                            Color(0xE6233157),
                            Color(0xE010182F),
                            Color(0xE00B1025),
                          ],
                  ),
                  border: Border.all(
                    color: isCurrentHour
                        ? const Color(0xFF9D8CFF)
                        : const Color(0xFF8193FF).withValues(alpha:0.28),
                    width: isCurrentHour ? 1.4 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withValues(alpha:
                        isCurrentHour ? 0.2 : 0.08,
                      ),
                      blurRadius: isCurrentHour ? 14 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                          isCurrentHour
    ? AppLocalizations.of(context)!.now
    : _formatHour(weather.hourlyTimes[i]),
                      style: TextStyle(
                        color: isCurrentHour
                            ? const Color(0xFFC4B5FD)
                            : const Color(0xFFD5E2FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  AnimatedWeatherIcon(
  icon: _weatherIcon(
    weather.hourlyWeatherCodes[i],
    time?.hour ?? 12,
  ),
  color: _weatherColor(
    weather.hourlyWeatherCodes[i],
    time?.hour ?? 12,
  ),
  weatherCode: weather.hourlyWeatherCodes[i],
),
                    Text(
                      '${weather.hourlyTemperatures[i].round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          color: Color(0xFF7DD3FC),
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${weather.hourlyPrecipitationProbabilities[i]}%',
                          style: const TextStyle(
                            color: Color(0xFF9DB4E8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}