import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart'; // Импорт локализации
import 'screens/product_list_screen.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// ...

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp(options: )
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('themeMode') ?? 0;
    setState(() {
      _themeMode = ThemeMode.values[themeIndex];
    });
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', themeMode.index);
  }

  void _toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate, // Локализация, сгенерированная командой gen-l10n
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: S.delegate.supportedLocales, // Поддерживаемые локали
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: ProductListScreen(
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
