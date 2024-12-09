import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event/event_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MainApp(prefs: prefs));
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

  late Locale _locale;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final String? savedLocale = widget.prefs.getString(localeKey);
    final String? savedThemeMode = widget.prefs.getString(themeModeKey);

    setState(() {
      _locale = savedLocale != null ? Locale(savedLocale) : const Locale('vi');
      _themeMode = savedThemeMode != null
          ? ThemeMode.values.firstWhere(
              (e) => e.toString() == savedThemeMode,
              orElse: () => ThemeMode.system,
            )
          : ThemeMode.system;
    });
  }

  void _handleLocaleChanged(Locale newLocale) async {
    await widget.prefs.setString(localeKey, newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  void _handleThemeModeChanged(ThemeMode newThemeMode) async {
    await widget.prefs.setString(themeModeKey, newThemeMode.toString());
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      home: EventView(
        onLocaleChanged: _handleLocaleChanged,
        onThemeModeChanged: _handleThemeModeChanged,
        currentLocale: _locale,
        currentThemeMode: _themeMode,
      ),
    );
  }
}
