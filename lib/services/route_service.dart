import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  RouteService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<LatLng>> fetchDrivingRoute({
    required LatLng pickup,
    required LatLng dropoff,
  }) async {
    final uri = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${pickup.longitude},${pickup.latitude};'
      '${dropoff.longitude},${dropoff.latitude}'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) {
        return [pickup, dropoff];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List<dynamic>;
      if (routes.isEmpty) {
        return [pickup, dropoff];
      }

      final geometry = routes.first['geometry'] as Map<String, dynamic>;
      final coordinates = geometry['coordinates'] as List<dynamic>;
      return coordinates.map((coordinate) {
        final pair = coordinate as List<dynamic>;
        return LatLng(
          (pair[1] as num).toDouble(),
          (pair[0] as num).toDouble(),
        );
      }).toList();
    } catch (_) {
      return [pickup, dropoff];
    }
  }
}
