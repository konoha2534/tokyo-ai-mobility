import 'place.dart';

class Reservation {
  const Reservation({
    required this.id,
    required this.pickup,
    required this.dropoff,
    required this.passengers,
    required this.departureTime,
    required this.estimatedWaitMinutes,
    required this.vehicleName,
    required this.routeDistanceKm,
    required this.createdAt,
    this.status = '予約済み',
  });

  final String id;
  final Place pickup;
  final Place dropoff;
  final int passengers;
  final String departureTime;
  final int estimatedWaitMinutes;
  final String vehicleName;
  final double routeDistanceKm;
  final DateTime createdAt;
  final String status;
}
