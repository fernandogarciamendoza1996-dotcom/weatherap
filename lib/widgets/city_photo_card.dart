
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CityPhotoCard extends StatelessWidget {
  final String? imageUrl;
  final String cityName;
  final String countryName;
  final bool loading;

  const CityPhotoCard({
    super.key,
    required this.imageUrl,
    required this.cityName,
    required this.countryName,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha:0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return _placeholder();
                },
              )
            else
              _placeholder(),

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha:0.78),
                  ],
                  stops: const [0.25, 1.0],
                ),
              ),
            ),

            if (loading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),

            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
  children: [
    const Icon(
      Icons.location_on_rounded,
      color: Color(0xFF93C5FD),
      size: 18,
    ),
    const SizedBox(width: 6),
    Text(
      AppLocalizations.of(context)!.explorePlace.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFFBFDBFE),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    ),
  ],
),
                  const SizedBox(height: 6),
                  Text(
                    cityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    countryName,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha:0.85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF101B3C),
            Color(0xFF312E81),
            Color(0xFF164E63),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.public_rounded,
          size: 64,
          color: Color(0xFFBFDBFE),
        ),
      ),
    );
  }
}

