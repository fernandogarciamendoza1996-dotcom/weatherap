import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WeatherMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const WeatherMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.10),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 250,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              latitude,
              longitude,
            ),
            initialZoom: 12,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.weatherap',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    latitude,
                    longitude,
                  ),
                  width: 50,
                  height: 50,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}