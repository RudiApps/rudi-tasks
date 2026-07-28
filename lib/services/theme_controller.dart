import 'package:flutter/material.dart';

import '../theme/rudi_theme.dart';
import 'theme_storage_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._storageService);

  final ThemeStorageService _storageService;

  AppThemeChoice _selectedTheme = AppThemeChoice.rudi;

  AppThemeChoice get selectedTheme => _selectedTheme;

  ThemeData get themeData {
    switch (_selectedTheme) {
      case AppThemeChoice.light:
        return RudiTheme.light;

      case AppThemeChoice.dark:
        return RudiTheme.dark;

      case AppThemeChoice.rudi:
        return RudiTheme.rudi;
    }
  }

  Future<void> loadTheme() async {
    _selectedTheme = await _storageService.loadTheme();
    notifyListeners();
  }

  Future<void> setTheme(AppThemeChoice theme) async {
    if (_selectedTheme == theme) {
      return;
    }

    _selectedTheme = theme;
    notifyListeners();

    await _storageService.saveTheme(theme);
  }
}