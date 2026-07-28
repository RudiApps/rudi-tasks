import 'package:flutter_test/flutter_test.dart';
import 'package:rudi_tasks/main.dart';

void main() {
  testWidgets('Rudi Tasks opens successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const RudiTasksApp());

    expect(find.text('Rudi Tasks'), findsOneWidget);
    expect(find.text('Держи задачи под контролем'), findsOneWidget);
  });
}