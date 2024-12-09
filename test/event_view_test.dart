import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_manager/event/event_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Widget createEventView() {
  return MaterialApp(
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
    home: EventView(
      onLocaleChanged: (_) {}, // Mock callback
      onThemeModeChanged: (_) {}, // Mock callback
      currentLocale: const Locale('vi'),
      currentThemeMode: ThemeMode.system,
    ),
  );
}

void main() {
  testWidgets('EventView test', (WidgetTester tester) async {
    await tester.pumpWidget(createEventView());
    expect(find.byType(EventView), findsOneWidget);
  });
}
