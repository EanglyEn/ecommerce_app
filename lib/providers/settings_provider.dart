import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier({ThemeMode initial = ThemeMode.system}) : super(initial);

  static const String _themeKey = 'theme_mode';

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier({Locale initial = const Locale('en')}) : super(initial);

  static const String _languageKey = 'language_code';

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}

const supportedLanguages = {
  'en': 'English',
  'km': 'ភាសាខ្មែរ',
};