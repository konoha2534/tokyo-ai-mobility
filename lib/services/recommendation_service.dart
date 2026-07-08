import 'package:latlong2/latlong.dart';

import '../models/place.dart';

class RecommendationResult {
  const RecommendationResult({
    required this.vehicleName,
    required this.distanceKm,
    required this.estimatedWaitMinutes,
    required this.message,
  });

  final String vehicleName;
  final double distanceKm;
  final int estimatedWaitMinutes;
  final String message;
}

class RecommendationService {
  RecommendationResult recommend({
    required Place pickup,
    required Place dropoff,
    required int passengers,
  }) {
    final distanceKm = const Distance().as(
      LengthUnit.Kilometer,
      pickup.point,
      dropoff.point,
    );
    final estimatedWaitMinutes = 5 + passengers * 2;

    return RecommendationResult(
      vehicleName: passengers >= 3 ? 'デマンドバス 12号車' : 'デマンドバス 23号車',
      distanceKm: distanceKm,
      estimatedWaitMinutes: estimatedWaitMinutes,
      message: passengers >= 3
          ? '乗車人数が多いため、相乗り効率を優先したルートをおすすめします。'
          : '待ち時間を抑えるため、最短到着を優先したルートをおすすめします。',
    );
  }
}
