import 'package:flutter/material.dart';

import 'app_card.dart';

class DashboardMetricsCard extends StatelessWidget {
  const DashboardMetricsCard({
    super.key,
    required this.todayReservations,
    required this.waitMinutes,
    required this.distanceKm,
  });

  final int todayReservations;
  final int waitMinutes;
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 620;
          final metrics = [
            _MetricItem(
              icon: Icons.event_available,
              label: '本日の予約',
              value: '$todayReservations件',
            ),
            _MetricItem(
              icon: Icons.timer,
              label: '予想待ち時間',
              value: '$waitMinutes分',
            ),
            _MetricItem(
              icon: Icons.route,
              label: '移動距離',
              value: '${distanceKm.toStringAsFixed(2)} km',
            ),
          ];

          if (wide) {
            return Row(
              children: metrics
                  .map((metric) => Expanded(child: metric))
                  .toList(),
            );
          }

          return Column(
            children: [
              for (final metric in metrics) ...[
                metric,
                if (metric != metrics.last) const Divider(height: 28),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
