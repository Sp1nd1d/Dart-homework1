import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Подготовка Flutter перед async кодом
  final prefs =
      await SharedPreferences.getInstance(); // Доступ к локальному хранилищу
  final isDark = prefs.getBool('darkMode') ?? false; // Чтение сохранённой темы

  runApp(
    ChangeNotifierProvider(
      create:
          (_) => ThemeProvider(
            initialDarkMode: isDark,
          ), // Передаём флаг темы в провайдер
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Получаем текущую тему

    return MaterialApp(
      title: 'News App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light, // Режим темы
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
