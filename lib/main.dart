import 'package:daily_wrapped/providers/gemini_notifier.dart';
import 'package:daily_wrapped/providers/interaction_notifier.dart';
import 'package:daily_wrapped/services/shared_preferences_services.dart';
import 'package:daily_wrapped/views/auth_page.dart';
import 'package:daily_wrapped/providers/spotify_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// 1. seclude the spotify package
// 2. use the gemini official package --done
// 3. add loading cassette animation --done
// 4. add share functionality
// 5. add preview music in the shared video
// 6. login page UI
// 7. deploy on play store
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MyApp());
}

void init() async {
  final sharedPreferencesService = SharedPreferencesService();
  sharedPreferencesService.init();
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<SpotifyNotifier>(
                create: (_) => SpotifyNotifier()),
            ChangeNotifierProvider<GeminiNotifier>(
                create: (_) => GeminiNotifier()),
            ChangeNotifierProvider<InteractionNotifier>(
                create: (_) => InteractionNotifier()),
          ],
          child: MaterialApp(
            title: 'Daily Wrapped',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: 'Franie'
            ),
            home: child,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
      child: const AuthPage(),
    );
  }
}
