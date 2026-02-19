import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:economic_influence/main.dart';
import 'package:economic_influence/services/purchase_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PurchaseService(),
        child: const EconomicInfluenceApp(),
      ),
    );
    expect(find.byType(EconomicInfluenceApp), findsOneWidget);
  });
}
