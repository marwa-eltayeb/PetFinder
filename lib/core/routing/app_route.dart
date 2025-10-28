import 'package:flutter/material.dart';
import 'package:petfinder/core/routing/routes.dart';
import '../../features/details/presentation/screens/details_screen.dart';
import '../../features/favourites/presentation/screens/favorites_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../utils/pet_type.dart';

class AppRouter {

  final String environment;
  AppRouter({required this.environment});

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboardingScreen:
        return MaterialPageRoute(builder: (_) => OnboardingScreen(environment: environment));

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case Routes.detailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final type = args['type'] as PetType;
        final petId = args['petId'] as String;
        return MaterialPageRoute(
          builder: (_) => DetailsScreen(type: type, petId: petId),
        );

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
