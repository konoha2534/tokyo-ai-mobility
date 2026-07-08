import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/place.dart';

class RouteMapCard extends StatelessWidget {
  const RouteMapCard({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.route,
    required this.loading,
  });

  final Place pickup;
  final Place dropoff;
  final List<LatLng> route;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: pickup.point,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.tokyo_ai_mobility',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: route,
                    strokeWidth: 5,
                    color: const Color(0xFF2563EB),
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pickup.point,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  Marker(
                    point: dropoff.point,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.flag,
                      size: 38,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (loading)
            Container(
              color: Colors.white.withValues(alpha: 0.55),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
