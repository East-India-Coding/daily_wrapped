import 'package:daily_wrapped/services/shared_preferences_services.dart';
import 'package:daily_wrapped/views/auth_page.dart';
import 'package:daily_wrapped/providers/spotify_auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferencesService = SharedPreferencesService();
  sharedPreferencesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SpotifyAuthNotifier>(
            create: (_) => SpotifyAuthNotifier()),
      ],
      child: MaterialApp(
        title: 'Daily Wrapped',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
