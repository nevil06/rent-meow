import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymanager/app/router.dart';
import 'package:mymanager/app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Prevent crash: google_fonts downloads fonts over HTTP at runtime.
  // If the download fails (no internet, timeout), the app crashes on startup.
  // This makes it fall back to the closest system font instead.
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(
    const ProviderScope(
      child: MyManagerApp(),
    ),
  );
}

class MyManagerApp extends StatelessWidget {
  const MyManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MyManager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('kn', ''),
        Locale('hi', ''),
      ],
    );
  }
}
