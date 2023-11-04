import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Home Screen E2E Test', () {
    testWidgets('', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(); // Aguardar todos os frames (animções)
      for (var i = 0; i < 5; i++) {}
    });
  });
}
