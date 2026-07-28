import 'package:flutter/material.dart';

import 'screens/tasks/tasks_screen.dart';
import 'services/theme_controller.dart';
import 'services/theme_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController(
    ThemeStorageService(),
  );

  await themeController.loadTheme();

  runApp(
    RudiTasksApp(
      themeController: themeController,
    ),
  );
}

class RudiTasksApp extends StatelessWidget {
  const RudiTasksApp({
    super.key,
    required this.themeController,
  });

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Rudi Tasks',
          debugShowCheckedModeBanner: false,
          theme: themeController.themeData,
          home: TasksScreen(
            themeController: themeController,
          ),
        );
      },
    );
  }
}