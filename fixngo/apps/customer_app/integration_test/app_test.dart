import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fixngo_customer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Customer App Integration Test', () {
    testWidgets('verify initial screen elements', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify some basic elements are present
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Look for common texts that might be on the login/splash screen
      // Since we don't have the exact DOM, we just do a generic check
      // to prove the automated integration framework is working.
      debugPrint('App loaded successfully in integration test environment!');
    });
  });
}
