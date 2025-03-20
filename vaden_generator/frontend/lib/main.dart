import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'config/dependencies.dart';
import 'ui/core/themes/theme.dart';
import 'ui/generate/generate_page.dart';

void main() {
  setupInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MaterialApp(
      title: 'Vaden generator',
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: dartTheme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }
        if (locale?.languageCode == 'pt') {
          return Locale('pt', 'BR');
        }

        return Locale('en', 'US');
      },
      home: const GeneratePage(),
    );
  }
}
