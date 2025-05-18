import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode; // Текущее состояние темы

  // Конструктор получает начальное значение (загруженное при запуске из main.dart)
  ThemeProvider({required bool initialDarkMode})
    : _isDarkMode = initialDarkMode;

  // Геттер — используется в UI
  bool get isDarkMode => _isDarkMode;

  // Переключает тему и сохраняет новое значение в SharedPreferences
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode; // Переключаем значение
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode); // Сохраняем в хранилище
    notifyListeners(); // Обновляем UI
  }
}
