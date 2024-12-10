import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:event_manager/settings/settings_view.dart';

Widget createTestWidget({
  required Locale locale,
  required ThemeMode themeMode,
  required Function(Locale) onLocaleChanged,
  required Function(ThemeMode) onThemeModeChanged,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    home: SettingsView(
      currentLocale: locale,
      currentThemeMode: themeMode,
      onLocaleChanged: onLocaleChanged,
      onThemeModeChanged: onThemeModeChanged,
    ),
  );
}

void main() {
  group('SettingsView Tests', () {
    testWidgets('Hiển thị đúng các thành phần UI cơ bản',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('vi'),
          themeMode: ThemeMode.light,
          onLocaleChanged: (_) {},
          onThemeModeChanged: (_) {},
        ),
      );

      await tester.pumpAndSettle();

      // Kiểm tra AppBar
      expect(find.text('Cài đặt'), findsOneWidget);

      // Kiểm tra các icon
      expect(find.byIcon(Icons.language), findsOneWidget);
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      // Kiểm tra các tiêu đề
      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(find.text('Chế độ tối'), findsOneWidget);

      // Kiểm tra các widget điều khiển
      expect(find.byType(DropdownButton<String>), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('Dropdown ngôn ngữ hiển thị đúng các tùy chọn',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('vi'),
          themeMode: ThemeMode.light,
          onLocaleChanged: (_) {},
          onThemeModeChanged: (_) {},
        ),
      );

      await tester.pumpAndSettle();

      // Kiểm tra giá trị hiện tại của dropdown
      expect(find.text('Tiếng Việt'), findsOneWidget);

      // Mở dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Kiểm tra các tùy chọn trong dropdown
      expect(find.text('Tiếng Việt'), findsWidgets);
      expect(find.text('Tiếng Anh'), findsOneWidget);
    });

    testWidgets('Thay đổi ngôn ngữ hoạt động đúng',
        (WidgetTester tester) async {
      Locale? changedLocale;

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('vi'),
          themeMode: ThemeMode.light,
          onLocaleChanged: (locale) {
            changedLocale = locale;
          },
          onThemeModeChanged: (_) {},
        ),
      );

      await tester.pumpAndSettle();

      // Mở dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Chọn Tiếng Anh
      await tester.tap(find.text('Tiếng Anh').last);
      await tester.pumpAndSettle();

      expect(changedLocale?.languageCode, equals('en'));
    });

    testWidgets('Thay đổi theme mode hoạt động đúng',
        (WidgetTester tester) async {
      ThemeMode? changedThemeMode;

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('vi'),
          themeMode: ThemeMode.light,
          onLocaleChanged: (_) {},
          onThemeModeChanged: (mode) {
            changedThemeMode = mode;
          },
        ),
      );

      await tester.pumpAndSettle();

      // Kiểm tra icon ban đầu
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      // Bật chế độ tối
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(changedThemeMode, equals(ThemeMode.dark));

      // Kiểm tra icon đã thay đổi
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('Tap vào ListTile chế độ tối cũng thay đổi theme',
        (WidgetTester tester) async {
      ThemeMode? changedThemeMode;

      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('vi'),
          themeMode: ThemeMode.light,
          onLocaleChanged: (_) {},
          onThemeModeChanged: (mode) {
            changedThemeMode = mode;
          },
        ),
      );

      await tester.pumpAndSettle();

      // Tap vào ListTile
      await tester.tap(find.text('Chế độ tối'));
      await tester.pumpAndSettle();

      expect(changedThemeMode, equals(ThemeMode.dark));
    });

    testWidgets('Card có elevation đúng', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('vi'),
          themeMode: ThemeMode.light,
          onLocaleChanged: (_) {},
          onThemeModeChanged: (_) {},
        ),
      );

      await tester.pumpAndSettle();

      final Card card = tester.widget<Card>(find.byType(Card).first);
      expect(card.elevation, 4.0);
    });

    testWidgets('Padding được áp dụng đúng', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          locale: const Locale('vi'),
          themeMode: ThemeMode.light,
          onLocaleChanged: (_) {},
          onThemeModeChanged: (_) {},
        ),
      );

      await tester.pumpAndSettle();

      final Padding padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(Scaffold),
              matching: find.byType(Padding),
            )
            .first,
      );
      expect(padding.padding, const EdgeInsets.all(16.0));
    });
  });
}
