import 'package:flutter_test/flutter_test.dart';

import 'package:tokyo_ai_mobility/app.dart';

void main() {
  testWidgets('dashboard renders the Japanese mobility app', (tester) async {
    await tester.pumpWidget(const TokyoAIMobilityApp());

    expect(find.text('TOKYO AI MOBILITY'), findsOneWidget);
    expect(find.text('AIデマンド交通予約プラットフォーム'), findsOneWidget);
    expect(find.text('AIデマンドバスを予約する'), findsOneWidget);
  });
}
