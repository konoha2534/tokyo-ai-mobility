import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../data/tokyo_places.dart';
import '../models/place.dart';
import '../models/reservation.dart';
import '../services/recommendation_service.dart';
import '../services/route_service.dart';
import '../widgets/ai_recommendation_card.dart';
import '../widgets/dashboard_metrics_card.dart';
import '../widgets/location_form_card.dart';
import '../widgets/route_map_card.dart';
import '../widgets/summary_hero_card.dart';
import 'reservation_success_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.totalReservations,
    required this.onReservationCreated,
  });

  final int totalReservations;
  final ValueChanged<Reservation> onReservationCreated;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _routeService = RouteService();
  final _recommendationService = RecommendationService();

  Place _pickup = tokyoPlaces[0];
  Place _dropoff = tokyoPlaces[1];
  List<LatLng> _route = [];
  bool _loadingRoute = false;
  int _passengers = 1;
  String _departureTime = departureTimes.first;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    setState(() => _loadingRoute = true);
    final route = await _routeService.fetchDrivingRoute(
      pickup: _pickup.point,
      dropoff: _dropoff.point,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _route = route;
      _loadingRoute = false;
    });
  }

  void _updatePickup(Place? value) {
    if (value == null) {
      return;
    }

    setState(() => _pickup = value);
    _loadRoute();
  }

  void _updateDropoff(Place? value) {
    if (value == null) {
      return;
    }

    setState(() => _dropoff = value);
    _loadRoute();
  }

  void _reserve() {
    final recommendation = _recommendationService.recommend(
      pickup: _pickup,
      dropoff: _dropoff,
      passengers: _passengers,
    );
    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString().substring(7),
      pickup: _pickup,
      dropoff: _dropoff,
      passengers: _passengers,
      departureTime: _departureTime,
      estimatedWaitMinutes: recommendation.estimatedWaitMinutes,
      vehicleName: recommendation.vehicleName,
      routeDistanceKm: recommendation.distanceKm,
      createdAt: DateTime.now(),
    );

    widget.onReservationCreated(reservation);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReservationSuccessPage(reservation: reservation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommendation = _recommendationService.recommend(
      pickup: _pickup,
      dropoff: _dropoff,
      passengers: _passengers,
    );
    final route = _route.isEmpty ? [_pickup.point, _dropoff.point] : _route;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOKYO AI MOBILITY',
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'AIデマンド交通予約プラットフォーム',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 20),
                SummaryHeroCard(
                  waitMinutes: recommendation.estimatedWaitMinutes,
                ),
                const SizedBox(height: 20),
                DashboardMetricsCard(
                  todayReservations: widget.totalReservations,
                  waitMinutes: recommendation.estimatedWaitMinutes,
                  distanceKm: recommendation.distanceKm,
                ),
                const SizedBox(height: 20),
                RouteMapCard(
                  pickup: _pickup,
                  dropoff: _dropoff,
                  route: route,
                  loading: _loadingRoute,
                ),
                const SizedBox(height: 20),
                LocationFormCard(
                  pickup: _pickup,
                  dropoff: _dropoff,
                  passengers: _passengers,
                  departureTime: _departureTime,
                  onPickupChanged: _updatePickup,
                  onDropoffChanged: _updateDropoff,
                  onPassengersChanged: (value) {
                    if (value != null) {
                      setState(() => _passengers = value);
                    }
                  },
                  onDepartureTimeChanged: (value) {
                    if (value != null) {
                      setState(() => _departureTime = value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                AiRecommendationCard(
                  recommendation: recommendation,
                  passengers: _passengers,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _reserve,
                    icon: const Icon(Icons.directions_bus),
                    label: const Text('AIデマンドバスを予約する'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
