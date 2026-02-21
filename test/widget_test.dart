import 'package:flutter_test/flutter_test.dart';
import 'package:goal_on_wall/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoalOnWallApp());
    // Verify the app builds without errors
    expect(find.text("Today's Flow"), findsOneWidget);
  });
}
