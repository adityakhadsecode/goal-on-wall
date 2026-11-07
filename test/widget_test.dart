import 'package:flutter_test/flutter_test.dart';
import 'package:goal_on_wall/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoalOnWallApp());
    // One frame is enough — the app has infinite ambient animations
    // (floating header, river painter) so pumpAndSettle would never end.
    await tester.pump();
    expect(find.text('Hi there'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
