import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:petfinder/core/routing/app_route.dart';
import 'package:petfinder/core/routing/routes.dart';
import 'core/di/injection_container.dart';
import 'core/presentation/cubit/theme_cubit.dart';
import 'core/utils/config.dart';
import 'core/theming/theme_data.dart';
import 'firebase_options.dart';

void mainCommon(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await initAll();

  Config.environment = environment;

  runApp(MyApp(environment: environment));
}

class MyApp extends StatelessWidget {
  final String environment;

  const MyApp({super.key, required this.environment});

  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    if (Config.isDev) {
      debugPrint("Running Development Flavor");
    }

    return BlocProvider(
      create: (_) => sl<ThemeCubit>()..loadSavedTheme(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: !Config.isProd,
            title: 'Pet Finder ($environment)',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            initialRoute: Routes.onboardingScreen,
            onGenerateRoute: AppRouter(environment: environment).generateRoute,
            navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics),],
          );
        },
      ),
    );
  }
}
