import 'package:flutter_test/flutter_test.dart';

import 'package:events_app/main.dart';

void main() {
  testWidgets('Events app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EventsApp());

    // Wait for the initial load to complete
    await tester.pump();

    // Verify that the app loads with the events screen
    expect(find.text('Eventos'), findsOneWidget);
    
    // Clean up any pending timers
    await tester.pumpAndSettle();
  });
}
