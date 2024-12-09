import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final Function(Locale) onLocaleChanged;
  final Function(ThemeMode) onThemeModeChanged;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;

  const SettingsView({
    super.key,
    required this.onLocaleChanged,
    required this.onThemeModeChanged,
    required this.currentLocale,
    required this.currentThemeMode,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late Locale _currentLocale;
  late ThemeMode _currentThemeMode;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.currentLocale;
    _currentThemeMode = widget.currentThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Ngôn ngữ'),
                      trailing: DropdownButton<String>(
                        value: _currentLocale.languageCode,
                        items: const [
                          DropdownMenuItem(
                            value: 'vi',
                            child: Text('Tiếng Việt'),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('Tiếng Anh'),
                          ),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _currentLocale = Locale(value);
                            });
                            widget.onLocaleChanged(_currentLocale);
                          }
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _currentThemeMode = _currentThemeMode == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark;
                      });
                      widget.onThemeModeChanged(_currentThemeMode);
                    },
                    child: ListTile(
                      leading: Icon(
                        _currentThemeMode == ThemeMode.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      title: const Text('Chế độ tối'),
                      trailing: Switch(
                        value: _currentThemeMode == ThemeMode.dark,
                        onChanged: (bool value) {
                          setState(() {
                            _currentThemeMode =
                                value ? ThemeMode.dark : ThemeMode.light;
                          });
                          widget.onThemeModeChanged(_currentThemeMode);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
