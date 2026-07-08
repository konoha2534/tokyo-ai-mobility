import 'package:flutter/material.dart';

class SummaryHeroCard extends StatelessWidget {
  const SummaryHeroCard({
    super.key,
    required this.waitMinutes,
  });

  final int waitMinutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0F766E)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'AIが予約需要を分析し、最適なデマンドバスルートを提案します。\n予想待ち時間：$waitMinutes分',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.directions_bus_filled,
            color: Colors.white,
            size: 52,
          ),
        ],
      ),
    );
  }
}
