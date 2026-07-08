import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const TokyoAIMobilityApp());
}

class TokyoAIMobilityApp extends StatelessWidget {
  const TokyoAIMobilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokyo AI Mobility',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const HomePage(),
    );
  }
}

class BusStop {
  final String name;
  final LatLng point;
  final String note;

  const BusStop(this.name, this.point, this.note);
}

const List<BusStop> busStops = [
  BusStop('東京都庁', LatLng(35.6895, 139.6917), '新宿エリアの主要拠点'),
  BusStop('東京医科大学病院', LatLng(35.6938, 139.6998), '医療施設への移動需要'),
  BusStop('新宿駅', LatLng(35.6896, 139.7006), '乗換需要が多い駅'),
  BusStop('中野坂上駅', LatLng(35.6978, 139.6826), '住宅地からの利用を想定'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BusStop start = busStops[0];
  BusStop goal = busStops[1];
  String timeSlot = '今日 17:30';
  int passengers = 1;
  bool reserved = false;

  List<LatLng> get routePoints {
    final via = busStops[2].point;
    if (start.name == goal.name) return [start.point];
    return [start.point, via, goal.point];
  }

  int get waitMinutes {
    final distance = const Distance().as(LengthUnit.Kilometer, start.point, goal.point);
    return (distance * 4 + passengers * 2).round().clamp(5, 18);
  }

  String get aiComment {
    if (passengers >= 3) {
      return 'AI判断：同方向の予約が多いため、新宿駅を経由する相乗りルートを推奨します。';
    }
    return 'AI判断：現在の予約状況では、最短距離を優先したルートを推奨します。';
  }

  void makeReservation() {
    setState(() => reserved = true);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('予約が完了しました'),
        content: Text('出発地：${start.name}\n目的地：${goal.name}\n乗車時間：$timeSlot\n予測待ち時間：$waitMinutes分'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 850;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: 22),
                  const _HeroCard(),
                  const SizedBox(height: 22),
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 7, child: _MapCard(routePoints: routePoints, start: start, goal: goal)),
                        const SizedBox(width: 20),
                        Expanded(flex: 5, child: _ControlPanel()),
                      ],
                    )
                  else ...[
                    _MapCard(routePoints: routePoints, start: start, goal: goal),
                    const SizedBox(height: 20),
                    _ControlPanel(),
                  ],
                  const SizedBox(height: 20),
                  _AiRouteCard(comment: aiComment, waitMinutes: waitMinutes, reserved: reserved),
                  const SizedBox(height: 20),
                  _TechCard(),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ControlPanel() {
    return Column(
      children: [
        _ReservationCard(
          start: start,
          goal: goal,
          timeSlot: timeSlot,
          passengers: passengers,
          waitMinutes: waitMinutes,
          onStartChanged: (value) {
            if (value != null) setState(() => start = value);
          },
          onGoalChanged: (value) {
            if (value != null) setState(() => goal = value);
          },
          onTimeChanged: (value) {
            if (value != null) setState(() => timeSlot = value);
          },
          onPassengersChanged: (value) => setState(() => passengers = value.round()),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: start.name == goal.name ? null : makeReservation,
            icon: const Icon(Icons.directions_bus),
            label: const Text('AI配車を予約する'),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOKYO AI MOBILITY',
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Smart Demand Bus\nPlatform',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, height: 1.15),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF0F766E)]),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'AIが予約状況を分析し、利用者の需要に合わせた最適な運行ルートを提案します。',
              style: TextStyle(color: Colors.white, fontSize: 18, height: 1.6, fontWeight: FontWeight.w600),
            ),
          ),
          Text('🚌', style: TextStyle(fontSize: 54)),
        ],
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  final List<LatLng> routePoints;
  final BusStop start;
  final BusStop goal;

  const _MapCard({required this.routePoints, required this.start, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 18, offset: Offset(0, 8))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: start.point,
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.tokyo_ai_mobility',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(points: routePoints, strokeWidth: 5, color: const Color(0xFF2563EB)),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: start.point,
                    width: 56,
                    height: 56,
                    child: const Icon(Icons.location_on, color: Color(0xFFDC2626), size: 42),
                  ),
                  Marker(
                    point: goal.point,
                    width: 56,
                    height: 56,
                    child: const Icon(Icons.flag, color: Color(0xFF16A34A), size: 38),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '${start.name} → ${goal.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final BusStop start;
  final BusStop goal;
  final String timeSlot;
  final int passengers;
  final int waitMinutes;
  final ValueChanged<BusStop?> onStartChanged;
  final ValueChanged<BusStop?> onGoalChanged;
  final ValueChanged<String?> onTimeChanged;
  final ValueChanged<double> onPassengersChanged;

  const _ReservationCard({
    required this.start,
    required this.goal,
    required this.timeSlot,
    required this.passengers,
    required this.waitMinutes,
    required this.onStartChanged,
    required this.onGoalChanged,
    required this.onTimeChanged,
    required this.onPassengersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('予約内容', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _StopDropdown(label: '出発地', value: start, onChanged: onStartChanged),
          const SizedBox(height: 12),
          _StopDropdown(label: '目的地', value: goal, onChanged: onGoalChanged),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: timeSlot,
            decoration: const InputDecoration(labelText: '乗車予定時間', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: '今日 17:30', child: Text('今日 17:30')),
              DropdownMenuItem(value: '今日 18:00', child: Text('今日 18:00')),
              DropdownMenuItem(value: '明日 09:00', child: Text('明日 09:00')),
            ],
            onChanged: onTimeChanged,
          ),
          const SizedBox(height: 16),
          Text('人数：$passengers人', style: const TextStyle(fontWeight: FontWeight.w600)),
          Slider(value: passengers.toDouble(), min: 1, max: 5, divisions: 4, label: '$passengers人', onChanged: onPassengersChanged),
          const Divider(height: 26),
          _RowItem(label: '予測待ち時間', value: '$waitMinutes分'),
          const SizedBox(height: 8),
          _RowItem(label: 'AIルート', value: passengers >= 3 ? '相乗り最適化' : '最短優先'),
        ],
      ),
    );
  }
}

class _StopDropdown extends StatelessWidget {
  final String label;
  final BusStop value;
  final ValueChanged<BusStop?> onChanged;

  const _StopDropdown({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<BusStop>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: busStops.map((stop) => DropdownMenuItem(value: stop, child: Text(stop.name))).toList(),
      onChanged: onChanged,
    );
  }
}

class _AiRouteCard extends StatelessWidget {
  final String comment;
  final int waitMinutes;
  final bool reserved;

  const _AiRouteCard({required this.comment, required this.waitMinutes, required this.reserved});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text('AIルート分析', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: const TextStyle(height: 1.6)),
          const SizedBox(height: 8),
          Text('予測待ち時間は約$waitMinutes分です。予約数・乗車人数・停留所間距離をもとに簡易スコアで算出しています。'),
          if (reserved) ...[
            const SizedBox(height: 12),
            const Chip(label: Text('予約済み：デモデータとして保存')),
          ],
        ],
      ),
    );
  }
}

class _TechCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = ['Flutter Web', 'OpenStreetMap', 'flutter_map', 'AI Route Simulation', 'GitHub'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) => Chip(label: Text(item))).toList(),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;

  const _RowItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
