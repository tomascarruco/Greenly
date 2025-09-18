import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:greenly/pages/home.dart';
import 'package:greenly/pages/authentication.dart';
import 'package:greenly/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  const appTitle = 'greenly';

  usePathUrlStrategy();

  await dotenv.load(fileName: '.env');

  final supaUrl = dotenv.maybeGet('SUPABASE_APP_URL');
  final supaAnonKey = dotenv.maybeGet('SUPABASE_PUBLISHABLE_KEY');

  if (supaAnonKey == null || supaUrl == null) {
    final supaUrlFound = supaUrl != null ? 'foound' : 'notFound';
    final supaAnonKeyFound = supaAnonKey != null ? 'foound' : 'notFound';

    print(
      'envLoading: Could not load env vals: supaAnonKey($supaAnonKeyFound) | supaUrlFound($supaUrlFound)',
    );

    // Gracefully shutdown
    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    exit(0);
  }

  await Supabase.initialize(url: supaUrl, anonKey: supaAnonKey, debug: true);

  runApp(const MainApp(appTitle));
}

final SupabaseClient supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  final String appTitle;

  const MainApp(this.appTitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
          surface: Color.fromRGBO(246, 250, 245, 100),
        ),
        textTheme: TextTheme(
          headlineSmall: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w700,
            fontSize: 26,
          ),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
          bodyMedium: const TextStyle(fontSize: 16),
          bodySmall: const TextStyle(fontSize: 14),
        ),
      ),
      home: supabase.auth.currentSession != null
          ? const HomePage()
          : const AuthenticationPage(),
    );
  }
}
