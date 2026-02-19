import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:abilli/main.dart';
import 'package:abilli/services/purchase_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PurchaseService(),
        child: const AbilliApp(),
      ),
    );
    expect(find.byType(AbilliApp), findsOneWidget);
  });
}
