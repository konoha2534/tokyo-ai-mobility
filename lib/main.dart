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
        fontFamily: 'Noto Sans JP',
      ),
      home: const HomePage(),
    );
  }
}

class BusStop {
  final String name;
  final String area;
  final LatLng point;

  const BusStop(this.name, this.area, this.point);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BusStop> stops = const [
    BusStop('東京都庁', '新宿区', LatLng(35.6895, 139.6917)),
    BusStop('東京医科大学病院', '新宿区', LatLng(35.6938, 139.6998)),
    BusStop('新宿駅', '新宿区', LatLng(35.6896, 139.7006)),
    BusStop('渋谷駅', '渋谷区', LatLng(35.6580, 139.7016)),
    BusStop('東京駅', '千代田区', LatLng(35.6812, 139.7671)),
  ];

  late BusStop startStop;
  late BusStop goalStop;
  bool reserved = false;

  @override
  void initState() {
    super.initState();
    startStop = stops[0];
    goalStop = stops[1];
  }

  int get distanceMeters {
    final d = const Distance();
    return d.as(LengthUnit.Meter, startStop.point, goalStop.point).round();
  }

  int get waitMinutes => (distanceMeters / 180).clamp(5, 18).round();

  int get rideMinutes => (distanceMeters / 260).clamp(6, 35).round();

  List<LatLng> get routePoints {
    final mid = LatLng(
      (startStop.point.latitude + goalStop.point.latitude) / 2 + 0.004,
      (startStop.point.longitude + goalStop.point.longitude) / 2,
    );
    return [startStop.point, mid, goalStop.point];
  }

  void reserveBus() {
    setState(() => reserved = true);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('予約が完了しました'),
        content: Text(
          'AIが予約状況を分析し、${startStop.name}から${goalStop.name}までの推奨ルートを作成しました。\n\n予測待ち時間：$waitMinutes分\n乗車時間：約$rideMinutes分',
        ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
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
                    'Smart Demand Bus\nPlatform',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _HeroCard(),
                  const SizedBox(height: 20),
                  _MapCard(
                    start: startStop,
                    goal: goalStop,
                    routePoints: routePoints,
                  ),
                  const SizedBox(height: 20),
                  _ReservationCard(
                    stops: stops,
                    startStop: startStop,
                    goalStop: goalStop,
                    waitMinutes: waitMinutes,
                    rideMinutes: rideMinutes,
                    distanceMeters: distanceMeters,
                    onStartChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        startStop = value;
                        if (startStop == goalStop) goalStop = stops.firstWhere((s) => s != startStop);
                        reserved = false;
                      });
                    },
                    onGoalChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        goalStop = value;
                        if (startStop == goalStop) startStop = stops.firstWhere((s) => s != goalStop);
                        reserved = false;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _AiInsightCard(
                    waitMinutes: waitMinutes,
                    rideMinutes: rideMinutes,
                    reserved: reserved,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: reserveBus,
                      icon: const Icon(Icons.directions_bus),
                      label: const Text('AI配車を予約する'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0F766E)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'AIが予約状況を分析し、最適な運行ルートを提案します。',
              style: TextStyle(color: Colors.white, fontSize: 18, height: 1.6),
            ),
          ),
          Text('🚌', style: TextStyle(fontSize: 54)),
        ],
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  final BusStop start;
  final BusStop goal;
  final List<LatLng> routePoints;

  const _MapCard({
    required this.start,
    required this.goal,
    required this.routePoints,
  });

  @override
  Widget build(BuildContext context) {
    final center = LatLng(
      (start.point.latitude + goal.point.latitude) / 2,
      (start.point.longitude + goal.point.longitude) / 2,
    );

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: FlutterMap(
        key: ValueKey('${start.name}-${goal.name}'),
        options: MapOptions(
          initialCenter: center,
          initialZoom: start.name == goal.name ? 15 : 12,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.tokyo_ai_mobility',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routePoints,
                strokeWidth: 5,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: start.point,
                width: 60,
                height: 60,
                child: const Icon(Icons.location_on, color: Color(0xFFDC2626), size: 42),
              ),
              Marker(
                point: goal.point,
                width: 60,
                height: 60,
                child: const Icon(Icons.flag, color: Color(0xFF2563EB), size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final List<BusStop> stops;
  final BusStop startStop;
  final BusStop goalStop;
  final int waitMinutes;
  final int rideMinutes;
  final int distanceMeters;
  final ValueChanged<BusStop?> onStartChanged;
  final ValueChanged<BusStop?> onGoalChanged;

  const _ReservationCard({
    required this.stops,
    required this.startStop,
    required this.goalStop,
    required this.waitMinutes,
    required this.rideMinutes,
    required this.distanceMeters,
    required this.onStartChanged,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('予約情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _StopDropdown(
            label: '出発地',
            value: startStop,
            stops: stops,
            onChanged: onStartChanged,
          ),
          const SizedBox(height: 14),
          _StopDropdown(
            label: '目的地',
            value: goalStop,
            stops: stops,
            onChanged: onGoalChanged,
          ),
          const Divider(height: 30),
          _RowItem(label: '予測待ち時間', value: '$waitMinutes分'),
          const SizedBox(height: 12),
          _RowItem(label: '推定乗車時間', value: '約$rideMinutes分'),
          const SizedBox(height: 12),
          _RowItem(label: '直線距離', value: '${distanceMeters}m'),
        ],
      ),
    );
  }
}

class _StopDropdown extends StatelessWidget {
  final String label;
  final BusStop value;
  final List<BusStop> stops;
  final ValueChanged<BusStop?> onChanged;

  const _StopDropdown({
    required this.label,
    required this.value,
    required this.stops,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 82,
          child: Text(label, style: const TextStyle(color: Color(0xFF64748B))),
        ),
        Expanded(
          child: DropdownButtonFormField<BusStop>(
            value: value,
            items: stops
                .map(
                  (stop) => DropdownMenuItem(
                    value: stop,
                    child: Text('${stop.name}（${stop.area}）'),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  final int waitMinutes;
  final int rideMinutes;
  final bool reserved;

  const _AiInsightCard({
    required this.waitMinutes,
    required this.rideMinutes,
    required this.reserved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF2563EB)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              reserved
                  ? '予約完了：AIが需要状況を分析し、待ち時間$waitMinutes分・乗車時間約$rideMinutes分のルートを提案しました。'
                  : 'AI分析：現在の予約状況をもとに、待ち時間$waitMinutes分・乗車時間約$rideMinutes分のルートを推奨しています。',
              style: const TextStyle(height: 1.6, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
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
