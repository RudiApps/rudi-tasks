import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rudi_tasks/main.dart';
import 'package:rudi_tasks/services/theme_controller.dart';
import 'package:rudi_tasks/services/theme_storage_service.dart';

void main() {
  testWidgets(
    'Rudi Tasks opens successfully',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final themeController = ThemeController(
        ThemeStorageService(),
      );

      await themeController.loadTheme();

      await tester.pumpWidget(
        RudiTasksApp(
          themeController: themeController,
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.text('Rudi Tasks'),
        findsOneWidget,
      );

      expect(
        find.text('Держи задачи под контролем'),
        findsOneWidget,
      );
    },
  );
}