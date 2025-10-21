import 'package:flutter/material.dart';
import 'package:petfinder/core/routing/app_route.dart';
import 'package:petfinder/core/routing/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet Finder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: Routes.onboardingScreen,
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
