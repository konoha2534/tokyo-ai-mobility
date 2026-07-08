import 'package:flutter/material.dart';

import '../models/reservation.dart';
import '../widgets/app_card.dart';
import '../widgets/info_row.dart';

class ReservationSuccessPage extends StatelessWidget {
  const ReservationSuccessPage({
    super.key,
    required this.reservation,
  });

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.check_circle,
                    size: 90,
                    color: Color(0xFF0F766E),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '予約が完了しました',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '予約番号：${reservation.id}',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 32),
                  AppCard(
                    child: Column(
                      children: [
                        InfoRow(
                          label: '乗車地',
                          value: reservation.pickup.name,
                        ),
                        InfoRow(
                          label: '目的地',
                          value: reservation.dropoff.name,
                        ),
                        InfoRow(
                          label: '乗車人数',
                          value: '${reservation.passengers}人',
                        ),
                        InfoRow(
                          label: '希望時刻',
                          value: reservation.departureTime,
                        ),
                        InfoRow(
                          label: '推奨車両',
                          value: reservation.vehicleName,
                        ),
                        InfoRow(
                          label: '移動距離',
                          value:
                              '${reservation.routeDistanceKm.toStringAsFixed(2)} km',
                        ),
                        InfoRow(
                          label: '予想待ち時間',
                          value: '${reservation.estimatedWaitMinutes}分',
                        ),
                        InfoRow(
                          label: 'ステータス',
                          value: reservation.status,
                        ),
                        const Divider(height: 28),
                        const Text(
                          '現在の乗車地・目的地・予約需要をもとに、AIが効率的な運行ルートを提案しました。次のフェーズではFirebaseによる予約データ保存を追加します。',
                          style: TextStyle(height: 1.6),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ダッシュボードへ戻る'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
