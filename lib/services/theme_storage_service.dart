import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeChoice {
  light,
  dark,
  rudi,
}

class ThemeStorageService {
  static const String _themeKey = 'rudi_tasks_theme';

  Future<void> saveTheme(AppThemeChoice theme) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _themeKey,
      theme.name,
    );
  }

  Future<AppThemeChoice> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);

    switch (savedTheme) {
      case 'light':
        return AppThemeChoice.light;

      case 'dark':
        return AppThemeChoice.dark;

      case 'rudi':
        return AppThemeChoice.rudi;

      default:
        return AppThemeChoice.rudi;
    }
  }
}