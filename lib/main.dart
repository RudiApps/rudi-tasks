import 'package:flutter/material.dart';

import 'screens/tasks/tasks_screen.dart';
import 'theme/rudi_theme.dart';

void main() {
  runApp(const RudiTasksApp());
}

class RudiTasksApp extends StatelessWidget {
  const RudiTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rudi Tasks',
      debugShowCheckedModeBanner: false,
      theme: RudiTheme.light,
      darkTheme: RudiTheme.dark,
      themeMode: ThemeMode.system,
      home: const TasksScreen(),
    );
  }
}