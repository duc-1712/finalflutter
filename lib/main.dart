// ignore_for_file: unused_import, unused_element

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event/event_view.dart';

void main() async {
  try {
    if (kDebugMode) {
      print('1. Starting app initialization');
    }
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    runApp(MainApp(prefs: prefs));
  } catch (e) {
    if (kDebugMode) {
      print('Error in main: $e');
    }
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Startup Error'),
        ),
      ),
    ));
  }
}

class MainApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MainApp({super.key, required this.prefs});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static const String localeKey = 'locale';
  static const String themeModeKey = 'themeMode';

  Locale _locale = const Locale('vi');
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('InitState called');
    }
    _loadSettings();
  }

  void _loadSettings() {
    if (kDebugMode) {
      print('Loading settings');
    }
    try {
      final String? savedLocale = widget.prefs.getString(localeKey);
      final String? savedThemeMode = widget.prefs.getString(themeModeKey);
      if (kDebugMode) {
        print('Loaded settings - locale: $savedLocale, theme: $savedThemeMode');
      }

      if (mounted) {
        setState(() {
          if (savedLocale != null) {
            _locale = Locale(savedLocale);
          }
          if (savedThemeMode != null) {
            _themeMode = ThemeMode.values.firstWhere(
              (e) => e.toString() == savedThemeMode,
              orElse: () => ThemeMode.system,
            );
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading settings: $e');
      }
    }
  }

  Future<void> _handleLocaleChanged(Locale newLocale) async {
    try {
      await widget.prefs.setString(localeKey, newLocale.languageCode);
      if (mounted) {
        setState(() {
          _locale = newLocale;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error changing locale: $e');
      }
    }
  }

  Future<void> _handleThemeModeChanged(ThemeMode newThemeMode) async {
    try {
      await widget.prefs.setString(themeModeKey, newThemeMode.toString());
      if (mounted) {
        setState(() {
          _themeMode = newThemeMode;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error changing theme: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Building MainApp');
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 51, 101, 144),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      locale: _locale,
      home: Scaffold(
        body: SafeArea(
          child: Builder(
            builder: (context) {
              try {
                // Tạm thời thay thế EventView bằng widget test

                return EventView(
                  onLocaleChanged: _handleLocaleChanged,
                  onThemeModeChanged: _handleThemeModeChanged,
                  currentLocale: _locale,
                  currentThemeMode: _themeMode,
                );
              } catch (e) {
                if (kDebugMode) {
                  print('Error building view: $e');
                }
                return Center(
                  child: Text('Error: $e'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
