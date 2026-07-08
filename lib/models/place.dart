import 'package:latlong2/latlong.dart';

class Place {
  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.point,
  });

  final String id;
  final String name;
  final String address;
  final LatLng point;
}
