import 'package:flutter/material.dart';
import 'package:petfinder/core/routing/routes.dart';
import '../../features/details/presentation/details_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case Routes.detailsScreen:
        final petId = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => DetailsScreen(petId: petId));

      case Routes.favoritesScreen:
        return MaterialPageRoute(builder: (_) => FavoritesScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}
