import 'package:flutter/material.dart';

import '../services/recommendation_service.dart';
import 'app_card.dart';
import 'info_row.dart';

class AiRecommendationCard extends StatelessWidget {
  const AiRecommendationCard({
    super.key,
    required this.recommendation,
    required this.passengers,
  });

  final RecommendationResult recommendation;
  final int passengers;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text(
                'AIルート提案',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InfoRow(label: '推奨車両', value: recommendation.vehicleName),
          InfoRow(
            label: '直線距離',
            value: '${recommendation.distanceKm.toStringAsFixed(2)} km',
          ),
          InfoRow(
            label: '予想待ち時間',
            value: '${recommendation.estimatedWaitMinutes}分',
          ),
          InfoRow(label: '乗車人数', value: '$passengers人'),
          const Divider(height: 28),
          Text(
            recommendation.message,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}
