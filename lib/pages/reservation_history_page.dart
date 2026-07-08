import 'package:flutter/material.dart';

import '../models/reservation.dart';
import '../widgets/app_card.dart';
import '../widgets/info_row.dart';

class ReservationHistoryPage extends StatelessWidget {
  const ReservationHistoryPage({
    super.key,
    required this.reservations,
  });

  final List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '予約履歴',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '本セッションで作成した予約を確認できます。Firebase連携後はFirestoreから取得します。',
                  style: TextStyle(color: Color(0xFF64748B), height: 1.5),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: reservations.isEmpty
                      ? const _EmptyHistory()
                      : ListView.separated(
                          itemCount: reservations.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _ReservationHistoryCard(
                              reservation: reservations[index],
                            );
                          },
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

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_note,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'まだ予約履歴がありません',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'ダッシュボードから予約を作成すると、ここに履歴が表示されます。',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ReservationHistoryCard extends StatelessWidget {
  const _ReservationHistoryCard({required this.reservation});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '予約番号：${reservation.id}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                label: Text(reservation.status),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          InfoRow(label: '乗車地', value: reservation.pickup.name),
          InfoRow(label: '目的地', value: reservation.dropoff.name),
          InfoRow(label: '希望時刻', value: reservation.departureTime),
          InfoRow(label: '推奨車両', value: reservation.vehicleName),
          InfoRow(
            label: '移動距離',
            value: '${reservation.routeDistanceKm.toStringAsFixed(2)} km',
          ),
          InfoRow(
            label: '予想待ち時間',
            value: '${reservation.estimatedWaitMinutes}分',
          ),
        ],
      ),
    );
  }
}
