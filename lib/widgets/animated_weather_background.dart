
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedWeatherBackground extends StatefulWidget {
  final Widget child;

  const AnimatedWeatherBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedWeatherBackground> createState() =>
      _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState
    extends State<AnimatedWeatherBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<_Star> _stars = [
    _Star(0.08, 0.09, 1.4, 0.3),
    _Star(0.19, 0.18, 2.2, 1.2),
    _Star(0.31, 0.07, 1.0, 2.1),
    _Star(0.43, 0.15, 1.5, 0.8),
    _Star(0.58, 0.08, 2.4, 1.7),
    _Star(0.72, 0.19, 1.2, 2.6),
    _Star(0.87, 0.10, 1.8, 0.4),
    _Star(0.94, 0.25, 1.0, 1.4),
    _Star(0.12, 0.31, 2.0, 2.5),
    _Star(0.27, 0.39, 1.1, 0.9),
    _Star(0.39, 0.29, 1.6, 1.8),
    _Star(0.67, 0.36, 2.0, 0.5),
    _Star(0.81, 0.43, 1.3, 2.2),
    _Star(0.95, 0.50, 2.1, 1.0),
    _Star(0.07, 0.54, 1.2, 1.5),
    _Star(0.21, 0.64, 1.8, 2.7),
    _Star(0.46, 0.55, 1.0, 0.6),
    _Star(0.61, 0.67, 2.3, 1.9),
    _Star(0.76, 0.59, 1.4, 0.2),
    _Star(0.89, 0.72, 1.7, 1.3),
    _Star(0.13, 0.82, 2.1, 2.4),
    _Star(0.34, 0.91, 1.3, 1.1),
    _Star(0.54, 0.85, 1.7, 2.0),
    _Star(0.70, 0.94, 1.1, 0.7),
    _Star(0.92, 0.88, 2.2, 1.6),
    _Star(0.49, 0.43, 1.0, 2.8),
    _Star(0.04, 0.72, 1.4, 0.1),
    _Star(0.84, 0.31, 1.1, 1.9),
    _Star(0.29, 0.76, 1.6, 0.3),
    _Star(0.64, 0.48, 1.2, 2.3),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final time = _controller.value;
        final screen = MediaQuery.sizeOf(context);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF02030B),
                Color(0xFF080D22),
                Color(0xFF10112C),
                Color(0xFF030611),
              ],
              stops: [0.0, 0.32, 0.68, 1.0],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Gran nube azul: profundidad de fondo.
              _nebula(
                left: -screen.width * 0.40 + math.sin(time * 2 * math.pi) * 24,
                top: -screen.height * 0.08,
                size: screen.width * 1.05,
                colors: const [
                  Color(0xFF1749C4),
                  Color(0xFF102B78),
                  Color(0x00102060),
                ],
                opacity: 0.48,
              ),

              // Nebulosa violeta: añade volumen.
              _nebula(
                right: -screen.width * 0.50 +
                    math.cos(time * 2 * math.pi) * 30,
                top: screen.height * 0.19,
                size: screen.width * 1.0,
                colors: const [
                  Color(0xFF7C3AED),
                  Color(0xFF44218F),
                  Color(0x001B123F),
                ],
                opacity: 0.34,
              ),

              // Resplandor cian.
              _nebula(
                left: -screen.width * 0.32 +
                    math.cos(time * 2 * math.pi) * 20,
                bottom: -screen.height * 0.15,
                size: screen.width * 0.95,
                colors: const [
                  Color(0xFF0891B2),
                  Color(0xFF155E9B),
                  Color(0x00102050),
                ],
                opacity: 0.28,
              ),

              // Segunda capa: nubes pequeñas que dan textura.
              _nebula(
                right: -screen.width * 0.12,
                bottom: screen.height * 0.25 +
                    math.sin(time * 2 * math.pi) * 18,
                size: screen.width * 0.55,
                colors: const [
                  Color(0xFF4F46E5),
                  Color(0xFF312E81),
                  Color(0x00131235),
                ],
                opacity: 0.24,
              ),

              // Velo oscuro para conservar el contraste de la interfaz.
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF02030B).withValues(alpha:0.15),
                      Colors.transparent,
                      const Color(0xFF02030B).withValues(alpha:0.42),
                    ],
                  ),
                ),
              ),

              // Cielo estrellado.
              ..._buildStars(screen, time),

              // Contenido original de la app.
              child!,
            ],
          ),
        );
      },
    );
  }

  Widget _nebula({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required List<Color> colors,
    required double opacity,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: IgnorePointer(
        child: RepaintBoundary(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.18, -0.15),
                radius: 0.75,
                colors: colors
                    .map((color) => color.withValues(
                          alpha: color.a * opacity,
                        ))
                    .toList(),
                stops: const [0.0, 0.42, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStars(Size screen, double time) {
    return _stars.map((star) {
      final twinkle =
          (math.sin(time * 2 * math.pi + star.phase) + 1) / 2;

      final brightness = 0.38 + twinkle * 0.62;
      final isBrightStar = star.size >= 2.0;

      return Positioned(
        left: screen.width * star.x,
        top: screen.height * star.y +
            math.sin(time * 2 * math.pi + star.phase) * 2.5,
        child: IgnorePointer(
          child: Opacity(
            opacity: brightness,
            child: SizedBox(
              width: star.size * (isBrightStar ? 4 : 2),
              height: star.size * (isBrightStar ? 4 : 2),
              child: Center(
                child: Container(
                  width: star.size,
                  height: star.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isBrightStar
                        ? const Color(0xFFDCEBFF)
                        : const Color(0xFFA5C8FF),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF60A5FA).withValues(alpha:
                          isBrightStar ? 0.85 : 0.45,
                        ),
                        blurRadius: isBrightStar ? 7 : 4,
                        spreadRadius: isBrightStar ? 1.2 : 0.4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double phase;

  const _Star(this.x, this.y, this.size, this.phase);
}

