import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheel_mobile/core/l10n/app_localizations.dart';
import 'package:wheel_mobile/core/theme/app_theme.dart';

/// Pumps [child] inside an Arabic, RTL MaterialApp (no network fonts).
Future<void> pumpApp(WidgetTester tester, Widget child) => tester.pumpWidget(
  MaterialApp(
    locale: const Locale('ar'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    theme: AppTheme.dark(useGoogleFonts: false),
    home: Scaffold(body: child),
  ),
);
